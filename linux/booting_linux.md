# Booting And System Management Daemons
The boot process consists of a few broadly defined tasks:
- Finding, loading, and running bootstrapping code.
- Finding, loading, and running the OS kernel
- Running startup scripts and system daemons
- Maintaining process hygiene and managing system state transitions (this continues as long as long as the system is running so it kind of blurs the line of "booting")
Here it is again in a little more detail:
- Power on
- Load BIOS/UEFI from NVRAM
- Probe for hardware
- Select boot device (disk, network, ...)
- Identify EFI system partition
- Load boot loader (e.g., GRUB, rEFInd)
- Determine which kernel to boot
- Load kernel
- Instantiate kernel data structures
- Start init/systemd as PID 1
- Execute startup scripts
- Running system
## Firmware
- When a machine is powered on, the CPU is hardwired to execute boot code stored in ROM. On virtualized systems, this "ROM" may be purely imaginary.
- The firmware typically knows all the devices on the motherboard. The firmware allows hardware-level configuration in addition to letting you either expose the hardware to the OS or disable and hide them.
- During normal bootstrapping, the system firmware probes for hardware and disks, runs a simple set of health checks, and then looks for the next stage of bootstrapping code. The boot device is typically designated using the BIOS or UEFI.
### BIOS vs. UEFI
- **BIOS** is the traditional PC firmware. It stands for "Basic Input/Output System"
  - BIOS can still be found in older systems.
  - Virtualized environments tend to adopt BIOS as their boot mechanism.
  - Details:
	- BIOS assumes that the boot device starts with a record called the MBR (Master Boot Record). The MBR includes a first-stage boot loader ("boot block") and a primitive disk partitioning table. This is typically less than 512 bytes.
	- Not sophisticated enough to read any standard filesystem, so the second-stage boot loader must be kept somewhere easy to find.
	- If using GRUB then the filesystem driver is stored in the first 64 blocks that are dead space before the first partition.
- **UEFI** is the newer standard. It stands for "Unified Extensible Firmware Interface," it is often referred to as "UEFI BIOS"
  - Most systems that implement UEFI can also fall back onto a legacy BIOS implementation if the OS its booting doesn't support UEFI
  - UEFI is the current revision of the earlier EFI standard. In all but the most technically explicit situations these terms are used interchangeably.
  - Support is pretty much universal on new PC hardware.
  - Details:
	- Includes a modern disk partitioning scheme known as GPT (GUID Partition Table, where GUID stands for "globally unique identifier")
	- Also capable of reading FAT (File Allocation Table) filesystems that are commonly used for flashdrives
	- Features combine to define the concept of an EFI System Partition (ESP).
	- At boot time, the firmware consults the GPT partition table to identify the ESP. It then reads the configured target application directly from a file in the ESP and executes it.
	- Because the ESP is just a generic FAT filesystem it can be mounted, read, written, and maintained by any operating system, effectively circumventing the weird secret boot partition used by BIOS implementations. 
	- No boot loader is technically required at all, as UNIX or Linux kernels can be valid UEFI boot targets (if configured for such a case). This isn't something that is often done in practice though.
	- UEFI defines standard APIs for accessing the system's hardware, it sort of acts like a mini-operating system. Operating systems can use the UEFI interface or take direct control of the hardware.
	- Because the UEFI has a formal API you can inspect UEFI variables on a running system. `efibootmgr -v` shows a summary of the boot configuration
## Boot Loaders
- Most bootstrapping procedures include the execution of a boot loader that is distinct from both the BIOS/UEFI code and the OS kernel.
- **The boot loader's main job is to identify and load an appropriate operating system kernel**
- Another task that falls on the boot loader is the marshaling of configuration arguments for the kernel. These can be hard-wired into the boot loader's config or provided on the fly in the boot loader's UI
## GRUB: The **GR**and **U**nified **B**oot Loader
- **GRUB** was developed by the GNU project. It is the default boot loader on most Linux distributions.
- GRUB has two main branches in it's lineage: the original Grub (now called GRUB Legacy), and the newer GRUB 2, which is the current standard.
  - Make sure you know which version of GRUB you're dealing with because the two versions are very different.
  - Most (if not all) major Linux distributions use Grub 2 as their default boot loader
### GRUB configuration
- GRUB lets you specify parameters such as the kernel to boot and the operating mode to boot into
- GRUB actually understands most filesystems in common use and can usually find its way to the root filesystem on its own, thus it is able to read its own configuration from a normal text file.
- The GRUB config file is called `grub.cfg` and its typically kept in `/boot/grub`
  - This file is typically generated by a tool so **if you make direct changes to it make sure you take the steps required to not have those changes be overwritten**
  - You typically should make changes to `etc/default/grub` which is the config file for the configuration generator. **Remember to run the generator after changing the generator config to actually apply the changes to GRUB**
- You can also specify boot time config options by pressing `c` to access the GRUB console while in the grub menu
## System Management Daemons
- Once the kernel has been loaded and has completed its initialization process, it creates a complement of "spontaneous" processes in user space.
  - These are called "spontaneous" because the kernel starts them autonomously.
  - Most of these processes are really part of the kernel implementation and don't correspond to programs in the filesystem
