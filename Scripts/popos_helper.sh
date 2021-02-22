#!/bin/bash

#The purpose of this script is to bind all non-boot GPUs to the vfio driver in PopOS 20.04

CPU=$(lscpu | grep GenuineIntel | rev | cut -d ' ' -f 1 | rev )

INTEL="0"

if [ "$CPU" = "GenuineIntel" ]
	then
	INTEL="1"
fi

echo "Please wait"

IDS="vfio-pci.ids=\""
BOOTGPU=""

#Identify a boot GPU

for i in $(find /sys/devices/pci* -name boot_vga); do
    if [ $(cat $i) -eq 1 ]; then

        BOOTGPU_PART=`lspci -n | grep $(echo $i | rev | cut -d '/' -f 2 | rev | cut -d ':' -f2,3,4)`
        BOOTGPU=$(echo $BOOTGPU_PART | cut -d ' ' -f 3)

        echo
        echo "Boot GPU:" `lspci -nn | grep $BOOTGPU`
    fi
done

#Identify any non-boot GPUs

for i in $(find /sys/devices/pci* -name boot_vga); do
    if [ $(cat $i) -eq 0 ]; then
        echo

        GPU=`echo $(dirname $i) | cut -d '/' -f6 | cut -d ':' -f 2,3,4 `
        GPU_ID=$(echo `lspci -n | grep $GPU | cut -d ':' -f 3,4 | cut -d ' ' -f 2`)

        #If a boot GPU has the same id as a non-boot GPU, then terminate 

        if [ $GPU_ID = $BOOTGPU ]
            then
                printf "ERROR! \nYour boot/primary GPU has the same id as one of the GPUs you are trying to bind to vfio-pci!\n"
                exit 1
        fi

        GPU_PATH=`echo $(dirname $i)`
        SRCH_PATH="${GPU_PATH:0:-1}*"

        #Identify the all GPU functions of detected GPUs

        for d in $(ls -d $SRCH_PATH); do
            #Add necessary commas to separate the ids
            if [[ $IDS != *"\"" ]]; then
                IDS+=","
            fi

            DEVICE=`echo $d | cut -d '/' -f 6 | cut -d ':' -f 2,3,4 `
            DEVICE_ID=$(echo `lspci -n | grep $DEVICE | cut -d ':' -f 3,4 | cut -d ' ' -f 2`)

            echo "Found:" `lspci -k | grep $DEVICE`

            #Build a string that will be passed to kernelstub
            IDS+=$(echo `lspci -n | grep $DEVICE_ID | cut -d ':' -f 3,4 | cut -d ' ' -f 2`)
        done
    fi
done

#complete ids

IDS+="\""

echo
echo $IDS

#Back up old kernel options

OLD_OPTIONS=`cat /boot/efi/loader/entries/Pop_OS-current.conf | grep options | cut -d ' ' -f 4-`

#Execute kernelstub resulting in GRUB being updated with vfio-pci.ids="..."

echo 

if [ $INTEL = 1 ]
	then
	kernelstub --add-options intel_iommu=on
	echo "Set Intel IOMMU On"
	else
	kernelstub --add-options amd_iommu=on
	echo "Set AMD IOMMU On"
fi

kernelstub --add-options $IDS

apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager ovmf

echo 
echo "Required packages installed"

#Create an uninstall script

echo "kernelstub -o \"$OLD_OPTIONS\"" > uninstall.sh
chmod +x uninstall.sh

# clear
echo
echo "Success! Non-primary GPUs were bound to vfio-pci. Please reboot your computer!"
echo
