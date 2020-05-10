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
  - You can find these in the `ps` listings by looking for low PIDs with brackets around their names.
  - The exception to this is the system management daemon, which has the PID of 1. It typically runs under the name **init**
### Responsibilities of init
- **init** has the overarching goal to make sure the system runs the right complement of services and daemons at any given time.
- init maintains a notion of the mode in which the system should be operating. Here are some commonly defined modes:
  - **Single-user mode** - Only a minimal set of filesystems is mounted, no services are running, and root shell is started in the console.
  - **Multiuser mode** - All customary filesystems are mounted and all configuration network services have been started, along with a window system and graphical login manager.
  - **Server mode** - Similar to multiuser mode, but with no GUI
- Every mode has a defined set of system services, the init daemon starts or stops those services as needed
- init also takes care of a lot of other startup chores that come with transitioning from bootstrapping to multiuser mode. These may include:
  - Setting the name of the computer
  - Setting the time zone
  - Checking disks with `fsck`
  - Mounting filesystems
  - Removing old files from the `/tmp` directory
  - Configuring network interfaces
  - Configuring packet filters
  - Stating up other daemons and network services
### Implementation of init
- There are three very different flavors of system management processes in widespread use:
  - An init styled after the init form AT&T's System V UNIX. This is referred to as **traditional init**. This was the most used init system prior to `systemd`
  - An init variant that derives from BSD UNIX and is used on most BSD-based systems. This is typically referred to as **BSD init**. Very simple in comparison to SysV-style init.
  - The modern implementation of init called **systemd**, which aims to be a one-stop-shopping for all daemon and state related issues. It thus tends to do much more than the historic implementations of init. Somewhat controversial because people think it does too much. Almost all major Linux distros have adopted systemd.
### Traditional init
- In traditional init, system modes are known as **run levels**
- Has a number of notable shortcomings (compared to systemd):
  - Is not really powerful enough to handle the needs of a modern system on its own. When it is used it typically has a set of secondary scripts that perform the actual hard work of changing run levels and letting administrators make config changes
  - That secondary script layer maintains a third layer of daemon and system specific scripts. This results in a pretty hackish and unsightly way to implement init.
  - The system has no general model of dependencies among services, so all startups and takedowns must be run in a numeric order that's maintained by the system admin. Because of this, it is also **impossible to execute actions in parallel**.
### systemd
- **systemd** takes all the init features that, were implemented in traditional init with sticky tape, shell script hacks, and admin pain, and formalizes them into a unified field theory of how services should be configured, accessed, and managed.
- systemd defines a robust dependency model, not only among its services but also its "targets," which are systemd's term for the operating modes (traditional init's run levels).
- systemd manages the following:
  - processes in parallel
  - network connections (networkd)
  - kernel log entries (journald)
  - logins (logind)
- There are people that don't like systemd, they say that it is fundamentally opposed to the UNIX philosophy, which is to keep system components small, simple, and modular. They also argue that because of systemd is doing so much it leads to complexity, introduces security weaknesses, and muddies the distinction between the OS platform and the services that run on top of it. Despite this systemd is very heavily used and will likely be the most popular init option for the foreseeable future.

## Reboot and Shutdown Procedures
- UNIX and Linux machines have historically been touchy about how they were shutdown, modern systems don't have nearly as many problems because of modern filesystems, but its still a good idea to shut down a machine nicely whenever possible.
- The `halt` command performs the essential duties required for shutting down the system.
  - `halt` preforms the following services:
	- logs the shutdown
	- kills nonessential processes
	- flushes cached filesystem blocks to disk
	- halts the kernel
  - `halt -p` actually powers down the system
- `reboot` is essentially the same as `halt` but it causes the machine to reboot rather than halting
- `shutdown` is a layer over halt and reboot and provides a scheduled shutdown, including a warning to any logged-in users. It is now largely obsolete unless you have a multi-user system.

## Stratagems for a Nonbooting System
- There are three basic approaches to solving this problem, here they are in a rough order of desirability:
  - Don't debug; just restore to a known-good state.
  - Bring the system up just enough to run a shell, and debug interactively.
  - Boot a separate system image, mount the sick system's filesystems, and investigate from there.
- The best way will typically be to boot to a shell, but restoring to a known-good state is great if you have a ultra-recent full backup.
- Booting to shell is known as **single-user** or **rescue mode**. Systems using systemd also have the even more primitive option of **emergency mode** which does the absolute minimum in preparation before starting the shell.
- If your system is already running, you can bring it down to single-user mode with a telinit (traditional init) or systemctl command
