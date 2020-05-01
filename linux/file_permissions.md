# File permissions
- You can use `ls -l foo.txt` to see the permissions of the file `foo.txt`
- File permissions are 12 bits
## Binary explanation
- `rw-` = 110 = 6 (from binary)
- `r--` = 100 = 4 (from binary)
- `r--` = 100 = 4 (from binary)
So `chmod 644 file.txt` means change the permissions to `rw- r-- r--`
## setuid
- This affects executables
- `ls -l /bin/ping` -> `rws r-x r-x root root`
The `s` in the first group means `ping` __always__ runs as root
## The file mode will determine what people can do to the file
- You can change this using `chmod` or `chown` to change the owner
- You really need to understand binary to understand what is going on with the file permissions
### File Permission code
```
- rwx r-- r--
```
- `-` File type
  - "-" indicates a file
  - "d" indicates a directory, directories are just fancy files
  - "l" indicates a link, links are just fancy files
- `rwx` User Permissions
  - Read, write, and execute permissions for the owner of the file
- first `r--` Group Permissions
  - Read, write, and execute permissions for members of the group owning the file
- second `r--` Others Permissions
  - Read, write, and execute permissions for other users
