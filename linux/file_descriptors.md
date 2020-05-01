# File Descriptors
- Unix systems use integers to track open files. These integers are called **file descriptors**
- `lsof` (list open files) will show you a process's open files
```bash
$ lsof -p 4242
FD  NAME
0   /dev/pts/tty1
1   /dev/pts/tty1
2   pipe:29174
3   /home/bee/textfile.txt
5   /tmp/
```
- Almost everything on Unix is a file so file descriptors can refer to many different things:
  - files on the disk
  - pipes
  - sockets (network connections)
  - terminals
  - devices
  - eventfd, inotify, signalfd, epoll, and more
- Whenever you read or white to a file/pipe/network connection you do so using a file descriptor
- Almost every process has 3 standard FDs
  - `stdin  -> 0`
  - `stdout -> 1`
  - `stderr -> 2`

