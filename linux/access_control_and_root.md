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
