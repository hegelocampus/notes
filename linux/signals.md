# Signals
- The Linux kernel sends your process signals in many different situations:
  - Child process is terminated.
  - Pipe is closed
  - Illegal instruction
  - Set timer expires
  - Segmentation fault
- Every signal has a default action, it is one of the following:
  - ignore
  - kill process
  - kill process **AND** make core dump file
  - stop process
  - resume process
- A program can set custom handlers for almost any signal. For example for `SIGTERM` the program will decide how/when it will handle that signal.
  - `SIGSTOP` and `SIGKILL` are exceptions and they cannot be ignored
- Signals can be hard to handle because they can happen at **any** time.

