# pop_OS-win10-KVM-setup
This is a repo that contains a tutorial and the necessary files to create a working Pop!\_OS 20.10 x86_64 -> windows 10 KVM.

  ![alt text](https://github.com/mr2527/pop_OS-win10-KVM-setup/blob/main/pop_Neofetch.png)

<h2 name="introduction">
  Introduction
</h2>

This KVM for Windows 10 will allow for PCIE and SATA devices to be passed through and used while having minimal performance loss that is directly comaparable to bare metal performance. 

<h3 name="reasoning/considerations">
  Reasoning/Consideration
</h3>

My reasoning for creating this was because at the time, I was and still am a new linux user that is also a big gamer. I did not want to abandon my chances of gaming with my want of moving over to a better development environment. I also did not want to necesarrily deal with the annoying dual booting that I have. It's just easier to pull my hairs out for a few days and learn to setup this than dual booting.

I spent nearly a week sifting through various guides getting this to environment to work (properly) on my desktop and I want to share the tips and tricks I've learned along the way and present a digestible way to getting your KVM / Virt-Manager set up (for windows 10) for new users. Some guides would get me halfway and then wouldn't provide me with enough information on where to go next. Then I would find a different guide that summed up the first up but left fine details out. All the guides I have read however are great and I want to give recognition to the individuals that helped me get this environment to work.

Please consider checking out these guides to find out where I was able to get my information from. I highly suggest it. The information is great.

With that being said, this guide will pull things from both guides and any others will be referenced appropriately.

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


Now here is a breakdown of my exact PC Setup. Please be aware that **there are differences** between AMD and Intel builds in regards to BIOS options and selecting the correct options. 

**I am on an AMD/NVIDIA build but I will make an effort to try and help intel users as well but your mileage may vary**

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
    - [G.Skill Trident Neo](https://www.gskill.com/product/165/326/1562839388/F4-3600C16Q-32GTZNTrident-Z-NeoDDR4-3600MHz-CL16-16-16-36-1.35V32GB-(4x8GB)) DDR4 3600 MHz 32GB (4x8)
- Disk:
    - [Samsung 970 EVO Plus 500GB](https://www.amazon.com/Samsung-970-EVO-Plus-MZ-V7S1T0B/dp/B07MFZY2F2) - M.2 NVMe (Passthrough)
    - [Samsung 860 PRO 2 TB](https://www.amazon.com/Samsung-512GB-V-NAND-Solid-MZ-76P512BW/dp/B07879KC15/ref=sr_1_2?dchild=1&keywords=860%2Bpro&qid=1613689682&s=electronics&sr=1-2&th=1) - SSD (Passthrough)
    - [WD Black NVME 500GB](https://shop.westerndigital.com/products/internal-drives/wd-black-sn750-nvme-ssd#WDS250G3X0C) - M.2 NVMe (Passthrough)
    - [WD Blue 500 GB - SSD](https://shop.westerndigital.com/products/internal-drives/wd-blue-sata-2-5-ssd#WDS500G2B0A) (Linux Host and qcow2 storage for windows 10 KVM)
    - [ADATA SSD 1TB - SSD](https://www.amazon.com/ADATA-Ultimate-Su800-Internal-ASU800SS-1TT-C/dp/B01K8A29E6) (Passthrough)

<h3 name="hardware_requirements">
  Hardware Requirements
</h3>

* Two graphics cards. (One for host system. One for guest system (passthrough))
* [Hardware that can support IOMMU](https://en.wikipedia.org/wiki/List_of_IOMMU-supporting_hardware) (Please read before proceeding).
* A monitor with more than one input or more than one monitor (Will be discussed later).


<h2 name="tutorial">
    Tutorial
</h2>

<h3 name="part1">
    Part 1: Prerequisites
</h3>
