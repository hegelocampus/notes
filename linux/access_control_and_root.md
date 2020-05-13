# Access Control and Root
## Standard UNIX Access Control
- The access control scheme follows a few basic rules:
  - Access control decisions depend on which user is attempting to perform an operation, or on that user's membership in a UNIX group.
  - **Objects (e.g., files and precesses) have owners**. Owners have broad (but not necessarily unrestricted) control over their objects.
  - You **own the objects you create.**
  - **root can act as the owner of any object.**
  - Only root can perform certain sensitive administrative operations.
- Some system calls check to see if the current user is root and simply rejects the operation if the user is not root. Other system calls implement different calculations that involve both ownership matching and special provisions for root.
- Filesystems have their own access control systems, which they implement in cooperation with the kernel's VFS layer. These access control systems tend to be much more elaborate and tend to take much greater advantage of UNIX groups.
- The entire access control paradigm is complicated by the fact that the kernel and the filesystem are intimately intertwined:
  - You control and communicate with most devices through files that represent them in `/dev`. Since device files are filesystem objects, they are subject to filesystem access control semantics.
  - The kernel uses that fact as its primary form of access control for devices.
### Filesystem access control
- Every file has both an owner and a group, sometimes referred to as the "group owner"
- The owner can set permissions for the file.
- Although the owner is always a single person, many people can be group owners of the file, as long as they are all part of a single group.
- Groups are traditionally defined in the `/etc/group` file, but now group info is often stored in a network database.
- The owner of a file gets to specify what group owners can do with it.
- You can get file ownership details with `ls -l`
- The kernel and the filesystem track owners and groups as numbers rather than as text names.
  - In the most basic case, user identification numbers (UIDs) are mapped to usernames in the `/etc/passwd` file, and group identification numbers (GIDs) are mapped to group names in `/etc/group`
  - The text names that correspond to UIDs and GIDs are defined only for convenience of the system's human users. When commands like ls attempt to display human-readable owner information they must look up each name that is associated with each file.
### The root account
- The root account is UNIX's omnipotent administrative user. It's also know as the superuser account.
- The defining characteristic of the root account is its UID of 0. Nothing prevents you from changing its username or adding new accounts with UIDs of 0, but both of those are very bad ideas.
- Traditional UNIX allows the superuser (that is, any process which has an effective UID of 0) to perform any valid operation on any file or process.
- Example restricted operations:
  - Creating device files
  - Setting the system clock
  - Raising resource usage limits and process priorities
  - Setting the system's hostname
  - Configuring network interfaces
  - Opening privileged network ports (those numbered below 1,024)

## Management of The Root Account
- Root access is required for system administration, its also a pivot point for system security.
### Root account login
- Since root is just a normal user you can login to the root account just like any other account. But that doesn't mean its a good idea and should be avoided in all but the most dire cases.
- Here is why this is bad:
  - Root logins leave no record of what operations were performed as root. This is not only bad because you can break things as root and not realize how; but when access was unauthorized and you're trying to figure out what an intruder has done to your system.
  - This also has the disadvantage of leaving no trace as to who actually performed a changed. If several people have root access you will have no way of knowing who used it and when.
- Most systems disallow root logins everywhere except the system console by default.
### su: substitute user identity
- `su` provides a marginally better way to access the root account.
- `su` when invoked without arguments prompts for the root password and then starts up a root shell. Root privileges then remain in effect until you terminate the shell by typing `<Control-D>` or the `exit` command
- Like logging in as root, `su` doesn't log the commands executed as root, but it **does create a log entry that states who became root and when**
- `su` can also be used to login to other users other than root. If you know someone's password, you can access that person's account directly by executing `su - username`. Like with root this will then prompt for the users password. Here the `-` will make `su` spawn the shell in login mode.
  - Login mode is important here because it will cause the shell to read `~/.bash_profile`, rather then `~/.bashrc` which it reads in nonlogin mode (wow I hate bash's config standard)
- root can `su` into any account without a password
- It's good to get into the habit of typing the full pathname to `su` (e.g., `/bin/su` or `/usr/bin/su`) than than relying on the shell to find the command for you in case someone has injected an arbitrary program called `su` into your path with the intent of harvesting passwords
- `su` has been largely superseded by `sudo` (because its much better), but it can still be useful in emergencies or for fixing situations in which `sudo` has been broken or misconfigured.
### sudo: limited su
- `sudo` **is the best, by far, and should be the primary method of access to the root account.**
- `sudo` takes as its argument a command line to be executed as root (or as another restricted user). `sudo` then consults the file `/etc/sudoers`, which lists the people who are authorized to use `sudo` and the commands they are allowed to run on each host. If the proposed command is permitted, `sudo` prompts for the **user's own** password and executes the command.
- Additional `sudo` commands can then be executed without the "doer" having to type their password until a five-minute period has passed (configurable) with no further `sudo` use.
- `sudo` keeps a log of the command lines that were executer, the hosts on which they were run, the people who ran them, the directories from which they were run, and the times at which they were invoked. This information can be logged by syslog or placed in the file of your choice.
- The biggest downside of `sudo` is that **any breach in the security of a sudoer's personal account can be equivalent to breaching the root account itself.** You can't really do much to counter this thread other than caution your sudoers to protect their own accounts as they would the root account.
- `sudo`'s default behavior is to pass only a minimal, sanitized environment to the commands it runs. If you need additional environment variables to be passed you can whitelist them in the `sudoers` file's `env_keep` list.
```sudoers
Defaults env_keep += "SSH_AUTH_SOCK"
Defaults env_keep += "DISPLAY XAUTHORIZATION XAUTHORITY"
```
- Beyond that you can preserve an environment variable that isn't listed in the `sudoers` file by setting it explicitly on the `sudo` command line:
```bash
$ sudo EDITOR=nvim vipw
```
- You can configure `sudo` to not prompt for a password but __**Do not do that**__

