# The Filesystem

### `chmod` change permissions
- The `chmod` command changes the permissions on a file.
- Only the owner of the file or superuser can change a file's permissions.
- The first argument is a specification of the permissions to be assigned, the second and subsequent arguments are name of files on which permissions should be changed.
- In the case of octal permissions, the first octal digit is for the owner, the second is for the group, and the third is for everyone else.
  - If you want to turn on the setuid, setgid, or sticky bits, you can use four octal digits rather than three.

#### Permission encoding for chmod
| Octal   | Binary   | Perms   |
| :-----: | :------: | :-----: |
| 0       | 000      | `---`     |
| 1       | 001      | `--x`     |
| 2       | 010      | `-w-`     |
| 3       | 011      | `-wx`     |
| 4       | 100      | `r--`     |
| 5       | 101      | `r-x`     |
| 6       | 110      | `rw-`     |
| 7       | 111      | `rwx`     |

#### `chmod`'s mnemonic syntax
| Spec       | Meaning                                                                 |
| :--------: | :---------------------------------------------------------------------: |
| `u+w`        | Write permission for the owner of the file                              |
| `ug=rw,o=r`  | Gives `r/w` permissions to owner and group, and read permission to others |
| `a-x`        | Removes execute permission for all categories (owner/group/other)       |
| `ug=srx,o=`  | Makes setuid/setgid and gives `r/x` permissions to only owner and group   |
| `g=u`        | Makes the group permissions be the same as the owner permissions        |

