# Common Interview Questions
## How can you check which kernel version a system is currently running?
  - `uname -a`
## Check current IP address
  - use `ip addr show` to get all info
## Check free disk space
  - `df -ah`, `df` gives an overview of the file system disk space usage
## How do you manage system services?
  - Depends on system
	- Newer systems will use `systemd`, which uses `systemctl`
	- Older systems use `system`
## Check total size of all items in a directory
  - `du -sh foo`, `du` = disk use
## How would you check for open ports?
  - `netstat -tulpn` will almost always show you everything you need, may need to run as root to get the information you need
## Check CPU usage for a process?
  - You can use `ps aux | grep foo`
  - I'd probably actually use `top` or `htop`
## How would you mount a new volume?
  - The device will appear in `/dev/`, its standard practice to mount volumes onto the `/mnt` directory
  - To mount on boot you use `fstab`
## How do you look something up
  - Read the damn man pages
  - Example section is normally at the bottom
  - You can also use Google, `tldr`, or StackOverflow

