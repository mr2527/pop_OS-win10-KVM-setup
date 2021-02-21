# pop!_OS-win10-KVM-setup

<h5 name="help">
  Spelling and grammar assistance by my buddy Isaiah, thank you.
</h5>

<h1 name="preface">
  PREFACE:
</h1>

You don't *need* strong terminal skills to do this, but it is highly suggested to know basic commands to get yourself through this, especially if you are not using user-friendly desktop environments or plan to do this entirely through the Terminal. If you don't have good terminal skills I suggest [this](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview) article

I have moderately strong terminal knowledge so this was a breeze for me, but I entirely understand new users who are wanting to get into the KVM environment after switching to Linux for the myriad of reasons that one may have(I don't blame you for moving. [Welcome to Linux!](https://livebook.manning.com/book/linux-in-action/chapter-1/10)).

If you are a seasoned UNIX/Linux/Related user, this may not be the guide for you as there will be a lot of simple hand holding information here. In that case might I suggest going to the [Arch](https://wiki.archlinux.org/index.php/KVM) KVM wiki or alternatively going to the guides listed [below](https://github.com/mr2527/pop_OS-win10-KVM-setup#--guides).

This is a repo that contains a tutorial and the necessary scripts to create a working [Pop!\_OS 20.10 x86_64](https://pop.system76.com/) -> Windows 10 KVM.

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/pop_Neofetch.png)
  
^If you want **this** information then simply install [neofetch](https://github.com/dylanaraps/neofetch):
```
$ sudo apt install neofetch
$ neofetch
```

<h2 name="introduction">
  Introduction
</h2>

This KVM for Windows 10 will allow for PCIE and SATA devices to be passed through and used while having minimal performance loss that is directly comparable to bare metal performance. 

<h3 name="reasoning/considerations">
  Reasoning/Consideration
</h3>

My reasoning for creating this was because at the time, I was and still am a new Linux user that is also a big gamer. I did not want to abandon my chances of gaming with my want of moving over to a better development environment. I also did not want to necessarily deal with the annoying dual booting that I have. It's just easier to pull my hairs out for a few days and learn to setup this than dual booting.

I spent nearly a week sifting through various guides getting this to environment to work (properly) on my desktop, and I want to share the tips and tricks I've learned along the way and present a digestible way to getting your KVM / Virt-Manager set up (for windows 10) for inexperienced users. Some guides would get me halfway and then wouldn't provide me with enough information on where to go next. Then I would find a different guide that summed up the first up but left delicate details out. All the guides I have read however are great and I want to give recognition to the individuals that helped me get this environment to work.

<h3 name="Guides">
  Guides:
</h3>

Please consider checking out these guides to find out where I was able to get my information from - I highly suggest it, The information is great.

This guide is designed to pull information from both sub-guides. All other guides will be referenced appropriately.

<h4 name="Bryan's Guide">
  Bryan's Guide:
</h4>

[Bryan Steiner (bryansteiner)](https://github.com/bryansteiner)

[Bryan's Guide](https://github.com/bryansteiner/gpu-passthrough-tutorial)

<h4 name="Aarons's Guide">
  Aarons's Guide:
</h4>

[Aaron Anderson (aaronanderson)](https://github.com/aaronanderson)

[Aaron's Guide](https://github.com/aaronanderson/LinuxVMWindowsSteamVR)


Below is a breakdown of my exact PC Setup. Please be aware that **there are differences** between AMD and Intel builds regarding BIOS options and selecting the correct options. 

**I am on an AMD/NVIDIA build but I will try to help Intel users as well, but your mileage may vary.**

<h3 name="hardware_setup">
    Hardware Setup
</h3>

- CPU:
    - [AMD Ryzen 9 3900X](https://www.amd.com/en/products/cpu/amd-ryzen-9-3900x)
- Motherboard:
    - [ROG Crosshair VIII Hero](https://rog.asus.com/us/motherboards/rog-crosshair/rog-crosshair-viii-hero-model/)
- GPUs:
    - [EVGA GTX 1080 Ti FTW3](https://www.evga.com/products/specs/gpu.aspx?pn=1190fbf7-7f11-465d-b303-cab0e50fbdc6)  (Host, I.e, Pop!\_OS) - PCIe slot 1
    - [EVGA RTX 3070 XC3 Ultra](https://www.evga.com/products/product.aspx?pn=08G-P5-3755-KR) (Guest, I.e, KVM) - PCIe slot 2
- Memory:
    - [G.Skill Trident Neo DDR4 3600 MHz 32GB](https://www.gskill.com/product/165/326/1562839388/F4-3600C16Q-32GTZNTrident-Z-NeoDDR4-3600MHz-CL16-16-16-36-1.35V32GB-(4x8GB)) (4x8)
- Disk:
    - [Samsung 970 EVO Plus 500GB](https://www.amazon.com/Samsung-970-EVO-Plus-MZ-V7S1T0B/dp/B07MFZY2F2) - M.2 NVMe (Passthrough)
    - [Samsung 860 PRO 2 TB](https://www.amazon.com/Samsung-512GB-V-NAND-Solid-MZ-76P512BW/dp/B07879KC15/ref=sr_1_2?dchild=1&keywords=860%2Bpro&qid=1613689682&s=electronics&sr=1-2&th=1) - SSD (Passthrough)
    - [WD Black NVME 500GB](https://shop.westerndigital.com/products/internal-drives/wd-black-sn750-nvme-ssd#WDS250G3X0C) - M.2 NVMe (Passthrough)
    - [WD Blue 500 GB - SSD](https://shop.westerndigital.com/products/internal-drives/wd-blue-sata-2-5-ssd#WDS500G2B0A) (Linux Host and qcow2 storage for windows 10 KVM)
    - [ADATA SSD 1TB - SSD](https://www.amazon.com/ADATA-Ultimate-Su800-Internal-ASU800SS-1TT-C/dp/B01K8A29E6) (Passthrough)

<h3 name="hardware_requirements">
  Hardware Requirements
</h3>

* Two graphics cards. (One for host system, One for guest system (passthrough))
* [Hardware that can support IOMMU](https://en.wikipedia.org/wiki/List_of_IOMMU-supporting_hardware) (Please read before proceeding).
* A monitor with more than one input or more than one monitor (Will be discussed later).

<h2 name="tips/tricks">
    Tips/Tricks
</h2>

1. If you are tired of having to enter a password for each sudo you do just do the following:
```
$ sudo -i
```
This will sign you into root.


2. Remember tab completion! It will make your life a lot easier when going back and forth between directories.


3. It's a confusing experience but I am sure you can get through it with some perseverance. Keep at it.


4. I suggest installing [Tree](https://www.computerhope.com/unix/tree.htm) to see how directories are laid out in the terminal (useful later!):
```
$ sudo apt install Tree
```

You can then run it simply by:
```
$ tree
```
It will produce output like this:

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/tree_example.png)


5. Basic Terminal commands. clear, ls, cd, mkdir, cp, etc.

<h2 name="tutorial">
    Tutorial
</h2>

<h3 name="part1">
    Part 1: Prerequisites
</h3>

Before anything, **it is required** to install these packages and download these files.

1. Update your OS if it is out of date:
```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get dist-upgrade
```

2. Download virtIO ISO files (***MANDATORY***)
Since this project is a KVM for Windows 10, you are required to download and use virtIO drivers. [virtIO] is a virtualization standard for network/disk device drivers. The addition of virtIO can be done by attaching the ISO to the windows VM in the application Virt-Manager (we will get this later). [Get the virtIO drivers here](https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/#virtio-win-direct-downloads)

3. Download Windows 10 ISO files (***MANDATORY***)
Since we are going to be creating a *Windows* kvm, you need the ISO for it. [Get the lastest Windows 10 ISO here](https://www.microsoft.com/en-us/software-download/windows10ISO)

4. ***OPTIONAL***:

<h4 name="AMD optional">
  If you own an AMD graphics card that you will be passing through:
</h4>

You don't *need* the Vulkan Drivers but if you want the best performance you can get on the host if it uses an AMD GPU I highly suggest this. Ubuntu comes with `mesa-vulkan-drivers` which offer comparable or better performance but you can get the AMD Vulkan drivers here:
```
$ sudo wget -qO - http://repo.radeon.com/amdvlk/apt/debian/amdvlk.gpg.key | sudo apt-key add -
$ sudo sh -c 'echo deb [arch=amd64] http://repo.radeon.com/amdvlk/apt/debian/ bionic main > /etc/apt/sources.list.d/amdvlk.list'
$ sudo apt update
$ sudo apt-get install amdvlk
```

5. Install the following packages (***MANDATORY***)
```
$ sudo apt install libvirt-daemon-system libvirt-clients qemu-kvm qemu-utils virt-manager ovmf
```
After this is completed, you are going to restart your PC and enter your BIOS. BIOS entry varies by manufacturer. In my case I can access it with F2, F8, or DEL. Enable the feature called `IOMMU`. Once this is completed you will then need to enable CPU virtualization. For Intel processors, you will need to enable `VT-d`. For AMD, look for something called `AMD-Vi` or in the case of my motherboard `SVM`/`SVM MODE` and enable it. Save your changes to the BIOS and then go back into pop!

Once you are logged back in you are going to want to run **this** command:

AMD:
```
$ dmesg | grep AMD-Vi
```

Intel:
```
$ dmesg | grep VT-d
```

If you get this error:
```
dmesg: read kernel buffer failed: Operation not permitted
```

Run it as sudo.
```
$ sudo dmesg | grep AMD-Vi
```

If you get output that looks like **this**, you should be ready.

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/grep_AMD-Vi.png)
  
Once this is completed you will need to pass this hardware enabled IOMMU functionality into the kernel. You can read more about [kernel parameters here](https://wiki.archlinux.org/index.php/kernel_parameters). Depending on your boot-loader you will have to figure out how to do this yourself. For me, I can use [kernelstub](https://github.com/pop-os/kernelstub). Other people use grub, GRUB2 or rEFInd.



AMD:
```
$ sudo kernelstub --add-options "amd_iommu=on"
```

Intel:
```
$ sudo kernelstub --add-options "intel_iommu=on"
```

If you use [GRUB2](https://help.ubuntu.com/community/Grub2), you can do it by going into /etc/default/grub with sudo permissions and include it into the kernel parameter below.

AMD:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on"
```

Intel:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_iommu=on"
```

As mentioned in [Bryan's guide](https://github.com/bryansteiner/gpu-passthrough-tutorial/blob/master/README.md), when planning the GPU passthrough setup, it was said to blacklist the NVIDIA/AMD drivers. "The logic stems from the fact that since the native drivers can't attach to the GPU at boot-time, the GPU will be freed-up and available to bind to the vfio drivers instead." The tutorials will make you add a parameter called `pci-stub` with the PCI bus ID of the GPU you wish to use. I did not follow this approach and instead dynamically unbind the drivers and bind `VFIO-PCI` drivers to it. Alternatively, you can run this script to bind the `VFIO-PCI` drivers to the secondary card in your PC. But it is important to understand IOMMU groupings. The script provided by [Bryan here](https://github.com/bryansteiner/gpu-passthrough-tutorial/blob/master/kvm/scripts/iommu.sh) is perfectly adequate for finding IOMMU groups, but I found [this script](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Scripts/iommu2.sh) to be better. 

The reason we want to use either script is to find the devices we want to passthrough (storage drivers, PCIe hardware, etc). [IOMMU](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) is a reference to the chipset device that maps virtual addresses to physical addresses on the input/output of the devices. At the end of this step we want to make sure that we have appropriate IOMMU groupings. The reason for this is you cannot separate the groupings.

Run the script:
```
./iommu2.sh
```

If you cannot run the script, with or withou sudo, then you should run:
```
chmod +x ./iommu2.sh
```
[chmod](https://en.wikipedia.org/wiki/Chmod) elevates permissions for files and in this case would allow you to run this without complications.

For AMD systems the output will look something like this:

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/iommu2.png)

Pulled from [Bryan's guide](https://github.com/bryansteiner/gpu-passthrough-tutorial/blob/master/README.md), Intel output should look like.

```
...
IOMMU Group 1 00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 07)
IOMMU Group 1 00:01.1 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor PCIe Controller (x8) [8086:1905] (rev 07)
IOMMU Group 1 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti Rev. A] [10de:1e07] (rev a1)
IOMMU Group 1 01:00.1 Audio device [0403]: NVIDIA Corporation TU102 High Definition Audio Controller [10de:10f7] (rev a1)
IOMMU Group 1 01:00.2 USB controller [0c03]: NVIDIA Corporation TU102 USB 3.1 Controller [10de:1ad6] (rev a1)
IOMMU Group 1 01:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU102 UCSI Controller [10de:1ad7] (rev a1)
IOMMU Group 1 02:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev e1)
IOMMU Group 1 02:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
...
```

If you have the problem presented in the Intel example, you have 2 options:
1. You can try swapping which PCI slot the graphics cards are in. This may or may not provide the expected results.
2. Alternatively you can conduct an [ACS Override Patch](https://queuecumber.gitlab.io/linux-acs-override/). It's *highly* worth it to read this post from [Alex Williamson](https://vfio.blogspot.com/2014/08/iommu-groups-inside-and-out.html). "Applying the ACS Override Patch may compromise system security. Check out this post to see why the ACS patch will probably never make its way upstream to the mainline kernel." 


<h4 name="part 1.1">
    ACS Override Patch (Optional):
</h4>

**PLEASE go to [Bryan's guide](https://github.com/bryansteiner/gpu-passthrough-tutorial/blob/master/README.md) and read how to do it there and understand the complications and implications.**

Since I did not need that part I will be skipping it. The next steps are applicable if you needed the patch or not. Dynamic binding is not necesarrily required. But it works in my case so I suggest looking into it. I will provide instructions below.


<h2 name="VM logistics">
***OPTIONAL*** VM Dynamic Binding
</h2>
How: Libvirt has a hook [Libvirt hooks](https://libvirt.org/hooks.html) system that grants you access to running commands on startup or shutdown of the VM. The scripts that are located within the directory `/etc/libvirt/hooks`. If the directory cannot be found or does not exist, create it. 

```
$ sudo mkdir /etc/libvirt/hooks
```

But lucky for us we have the [hook helper](https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/) which can be ran as followed:
```
$ sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \-O /etc/libvirt/hooks/qemu
$ sudo chmod +x /etc/libvirt/hooks/qemu
```

Now restart the libvirt to use the hook helper:
```
$ sudo service libvirtd restart
```

If you want to dynamically bind the VFIO-PCI drivers before the VM starts and unbind after you end it, you can do as follows:

Recognize the most important hooks
```
# Before a VM is started, before resources are allocated:
/etc/libvirt/hooks/qemu.d/$vmname/prepare/begin

# Before a VM is started, after resources are allocated:
/etc/libvirt/hooks/qemu.d/$vmname/start/begin

# After a VM has started up:
/etc/libvirt/hooks/qemu.d/$vmname/started/begin

# After a VM has shut down, before releasing its resources:
/etc/libvirt/hooks/qemu.d/$vmname/stopped/end

# After a VM has shut down, after resources are released:
/etc/libvirt/hooks/qemu.d/$vmname/release/end
```

I have named my VM "pop" for this example. My directory structure is:

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/pop_tree_struct.png)

Now is when things get fun. Create a file named `kvm.conf`. My editor of choice is [vim](https://www.vim.org/). If you want to avoid problems when creating these files:
```
$ sudo $editor_you_want_to_use kvm.conf
```

Once you have the file open add these entries:
```
## Virsh devices
VIRSH_GPU_VIDEO=pci_0000_0b_00_0
VIRSH_GPU_AUDIO=pci_0000_0b_00_1
```
These are how my groupings are made so you are **required* to find your correct groupings and place them here. If you forget where to get them, use the iommu2.sh script by:
```
$ ./iommu2.sh
```

The output of the script will translate the address for each device. Ex: `IOMMU group 27 0b:00.0` which is written as --> `VIRSH_GPU_VIDEO=pci_0000_0b_00_0`. You will need to figure this out on your own! 

Once you got the currect bus addresses you can then move on to create some scripts:

`bind_vfio.sh`:
```
#!/bin/bash

## Load the config file
source "/etc/libvirt/hooks/kvm.conf"

## Load vfio
modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio_pci

## Unbind gpu from nvidia and bind to vfio
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
```

`unbind_vfio.sh`:
```
#!/bin/bash

## Load the config file
source "/etc/libvirt/hooks/kvm.conf"

## Unbind gpu from vfio and bind to nvidia
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

## Unload vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio
```

My script varies from [Bryan's](https://github.com/bryansteiner/gpu-passthrough-tutorial#----part-2-vm-logistics) by removing groupings I do not have. It works for me. You may need to tweak it some.

Once the scripts are created, chmod them:
```
$ chmod +x bind_vfio.sh unbind_vfio.sh
```
If this doesn't work, just add sudo to the front.

It should look like the image above once completed. You should be all set in this case. Tweaks to the VM will be made later or you can skip the tweaks. I skipped some tweaks and my performance is just fine.

Take a breather! We are almost there!

<h2 name="part3">
  Creating the VM in Virt-Manager
</h2>

Once you are here we can begin the construction of our VM. If you are a new user I suggest the GUI approach that I will describe. Otherwise you can take a read [YuriAlek's series of GPU passthrough scripts](https://gitlab.com/YuriAlek/vfio). The scripting is obviously more involved and takes some skill to process. The GUI approach is easier. There is nothing wrong with this approach!

You can now start [Virt-Manager](https://virt-manager.org/), you will be presented with this screen:

<p align="center">
  <img width="600" height="600" src="https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/virt1.png">
</p>

Click on the screen with yellow light icon or navigate to `File > Add Connection`. You will be presented with this screen. Choose `Local install media (ISO image or CDROM)` and select `Forward`. You will then see:

<p align="center">
  <img width="600" height="600" src="https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/virt2.png">
</p>

Remember those ISOs we installed earlier? We are going to need them now. I store them on my `Desktop/`. Store them wherever you want and navigate to that installation location by selecting the `browse` button. Choose the Win10 ISO. The `Choose the operating system you are installing:` section should now autocomplete. Keep the button checked and continue `Forward`. You will be presented with:

<p align="center">
  <img width="600" height="600" src="https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/virt3.png">
</p>

You will now configure your Memory (RAM) and CPU settings. In my case, I will designate 16GB of ram for now (16384) and since I have a 12c/24t CPU, I will pass in all 12 cores. Proceed `Forward` and be met with:

<p align="center">
  <img width="600" height="600" src="https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/virt4.png">
</p>

In this case you will be creating a custom storage for the Windows install. Select `Enable storage for this virtual machine` and then `Select or create custom storage` and then navigate the Storage Volume menu and create a storage volume with any size above 50GB. In this case you want to create a storage volume with any name you would like and with a format of `qcow2` the rest doesn't matter. It can be stored wherever you like. Once created select it and proceed with `Choose Volume` and lastly go `Forward`. 

<p align="center">
  <img width="600" height="600" src="https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/virt6.png">
</p>

***NOTE***: I had a problem when I initially created this because I named it `win10`. I highly suggest NOT naming it this. Instead do `Windows10` if you really want. Lastly select `Customize configuration before install` and then `Finish`.

A new window will now appear called `$VM_NAME on QEMU/KVM`. This will allow you to configure more advanced options. You can alter these options through GUI or libvirt XML settings. Please ensure that while on the `Overview` page under `Firmware` you select `UEFI x86_64: /usr/share/OVMF_CODE_4M.fd` and none of the other options.

<p align="center">
  <img width="600" height="600" src="https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/Photos/virt7.png">
</p>
