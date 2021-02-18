# pop_OS-win10-KVM-setup
This is a repo that contains a repo and the necessary files to create a working pop_OS -> windows 10 KVM.


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

<h4 name="Bryan's Guide">
  Bryan's Guide
</h4>

[Bryan Steiner (bryansteiner)](https://github.com/bryansteiner)

[Bryan's Guide](https://github.com/bryansteiner/gpu-passthrough-tutorial)

<h4 name="Aarons's Guide">
  Aarons's Guide
</h4>

[Aaron Anderson](https://github.com/aaronanderson)

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
    - EVGA GTX 1080 Ti FTW3  (Host, I.e, pop_OS) - PCIe slot 1
    - EVGA RTX 3070 XC3 Ultra (Guest, I.e, KVM) - PCIe slot 2
- Memory:
    - G.Skill Trident Neo DDR4 3600 MHz 32GB (4x8)
- Disk:
    - Samsung 970 EVO Plus 500GB - M.2 NVMe (Passthrough)
    - Samsung 860 PRO 2 TB - SSD (Passthrough)
    - WD Black NVME 500GB - M.2 NVMe (Passthrough)
    - WD Blue 500 GB - SSD (Linux Host and qcow2 storage for windows 10 KVM)
    - ADATA SSD 1TB - SSD (Passthrough)

<h2 name="tutorial">
    Tutorial
</h2>

<h3 name="part1">
    Part 1: Prerequisites
</h3>
