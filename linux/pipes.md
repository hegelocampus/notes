# Pipes
- Pipes are used to send the output of one process into the input of another
- A pipe is a pair of 2 magical file descriptors, `1` pipe input and `2` pipe output.
- Pipes are one-way. A program cannot write to the out pipe
- Linux creates a __buffer__ for each pipe.
  - If data gets written to the pipe faster than it's read the buffer will fill up.
  - When the buffer is full, writes to in will block (wait) until the reader reads. This is normal and is not necessarily something you should try to avoid.
- What if the target process dies?
  - If the target process dies, the pipe will close and the in process will be sent `SIGPIPE`, which by default terminates the process.
#### Named pipes
```bash
$ mkfifo my-pipe
```
- This lets multiple unrelated processes communicate through a pipe.
- The programs can read/write to this pipe just like a file (because it is a file).
