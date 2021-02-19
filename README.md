# pop_OS-win10-KVM-setup

<h5 name="help">
  Spelling and grammar assistance by my buddy Isaiah, thank you.
</h5>

This is a repo that contains a tutorial and the necessary scripts to create a working Pop!\_OS 20.10 x86_64 -> windows 10 KVM.

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/pop_Neofetch.png)
  
^If you want **this** information then simply:
```
$ sudo apt install neofetch
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

**I am on an AMD/NVIDIA build but I will try to help intel users as well, but your mileage may vary.**

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


<h2 name="tutorial">
    Tutorial
</h2>

<h3 name="part1">
    Part 1: Prerequisites
</h3>



Before anything, **it is required** to install these packages.
```
$ sudo apt install libvirt-daemon-system libvirt-clients qemu-kvm qemu-utils virt-manager ovmf
```
After this is completed, you are going to want to restart your pc and enter your BIOS. BIOS entry varies by manufacturer. In my case I can access it with F2, F8, or DEL. Enable the feature called `IOMMU`. Once this is completed you will then need to enable CPU virtualization. For Intel processors, you will need to enable `VT-d`. For AMD, look for something called `AMD-Vi` or in the case of my motherboard `SVM`/`SVM MODE` and enable it. Save your changes to the BIOS and then go back into pop!

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

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/grep_AMD-Vi.png)
  
Once this is completed you will need to pass this hardware enabled IOMMU functionality into the kernel. You can read more about [kernel parameters here](https://wiki.archlinux.org/index.php/kernel_parameters). Depending on your boot-loader you will have to figure out how to do this yourself. For me, I can use [kernelstub](https://github.com/pop-os/kernelstub). Other people use grub, GRUB2 or rEFInd.



AMD:
```
$ sudo kernelstub --add-options "amd_iommu=on"
```

Intel:
```
$ sudo kernelstub --add-options "intel_iommu=on"
```

If you use GRUB2, you can do it by going into /etc/default/grub with sudo permissions and include it into the kernel parameter below.

AMD:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on"
```

Intel:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_iommu=on"
```
