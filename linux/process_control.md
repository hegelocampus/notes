# Process Control
- A process is an abstraction of a running program that allows its memory, processor time, and I/O resources to be managed and monitored.
- It is an axiom of the UNIX philosophy that as much work as possible be done within the context of process rather than being handled specially by the kernel. System and user processes follow the same rules, so you can use a single set of tools to control them both.

## Components of a Process
- A process consists of address space and a set of data structures within the kernel.
  - The address space is a set of memory pages that the kernel has marked for the process's use. 
	- These pages contain the following: 
	  - The code and libraries that the process is executing
	  - The process's variables
	  - The process's stacks
	  - Various extra information needed by the kernel while the process is running.
	- The process's virtual address space is laid out randomly in physical memory and tracked by the kernel's page tables.
  - The kernel's internal data structures record various pieces of information about each process. Here are some important things that are stored:
	- The process's address space map.
	- The current status of the process (sleeping, stopped, runnable, etc.).
	- The execution priority of the process.
	- Information about the resources the process has used (CPU, memory, etc.).
	- Information about the files and network ports the process has opened.
	- The process's signal mask (a record of which signals are blocked).
	- The owner of the process.
- A "thread" is an execution context within a process. 
  - Every process has at least one thread, but some processes have many. 
  - **Each thread has its own stack and CPU context, but operates within the address space of its enclosing process.**

### PID: Process ID Number
- The kernel assigns a unique ID number to every process.
- Most commands and system calls that manipulate processes require you to specify a PID to identify the target of the operation.
- PIDs are assigned in order as processes are created.
- Linux also has process "namespaces,"
  - These further restrict process' ability to see and affect each other.
  - Container implementations use this feature to keep processes segregated.
  - One side effect is that a process might appear to have different PIDs depending on the namespace of the observer.

### PPID: parent PID
- Neither UNIX nor Linux has a system call that initiates a new process running a particular program. Instead, it's done in two separate steps:
  - First, an existing process must clone itself to create a new process.
  - The clone then exchanges the program it's running for a different one.
- When a process is cloned, the original process is referred to as the parent, and the copy is called the child. **The PPID attribute of a process is the PID of the parent form which it was cloned.**
  - If the original parent dies, `init` or `systemd` becomes the new parent.
- The PPID is useful for tracing unknown or misbehaving processes back to their origin.

### UID and EUID: real and effective user ID
- Usually only the creator (i.e., the owner) and the superuser can manipulate a process.
- **A process's UID is the user identification number of the person who created it, or more accurately, it is a copy of the UID value of the parent process.**
- The EUID is the "effective" user ID, an extra UID that **determines what resources and files a process has permission to access sat any given moment.**
  - For most processes, the UID and EUID are the same, the usual exception being processes that are setuid.
- Most systems also keep track of a "saved UID," which is a copy of the process's EUID at the point at which the process first begins to execute
- Linux also defines a nonstandard FSUID process parameter that controls the determination of filesystem permissions.
  - It is infrequently used outside the kernel and is not portable to other UNIX systems.

### GID and EGID: real and effective group ID
- The GID is the group identification number of a process. The EGID is related to the GID in the same way that the EUID is related to the UID in that it can be "upgraded" by the execution of a setgid program.
- The GID attribute of a process is largely vestigial. This is because a process can be a member of many groups at once. The complete group list is stored separately from the distinguished GID and EGID. **Determinations of the access permissions normally take into account the EGID and the supplemental group list, but not the GID itself.**
- The only time at which the GID is significant is when a process creates new files. Depending on how the filesystem permissions have been set, new files might default to adopting the GID of the creating process.

### Niceness
- **A process's scheduling priority determines how much CPU time the process receives.**
- The kernel computes priorities with a dynamic algorithm that takes into account the amount of CPU time that a process has recently consumed and the length of time it has been waiting to run.
  - The kernel also pays attention to the administratively set "niceness," which specifies how nice you are planning to be to other users of the system.
- This is discussed in detail on page 102.

### Control terminal
- Most nondaemon processes have an associated control terminal.
- The control terminal determines the default linkages for the standard input, standard output, and standard error channels.
- It also distributes signals to processes in response to keyboard events such as \<Control-C\>.
- Actual terminals are rare, but when you start a command from the shell, your terminal emulator window typically becomes the process's control terminal.

## The Life Cycle of a Process
- To create a new process, a process copies itself with the **fork** system call.
- `fork` creates a copy of the original process, and that copy is largely identical to the parent. The new process has a distinct PID and has its own accounting information.
- `fork` has the unique property of returning two different values.
  - From the child's point of view, it returns zero.
  - The parent receives the PID of the newly created child.
- Since the parent and the child are otherwise identical, they must examine the return value of the `fork` call to figure out which role they are supposed to play.
- After a `fork`, the child process often uses one the `exec` family of routines to begin the execution of a new program. **These change the program that the process is executing and reset the memory segments to a predefined initial state.**
- `init` (or `systemd`) plays the important role in process management of calling a routine named `_exit`. This routine notifies the kernel that the process is ready to die. This process is supplied an exit code (which is represented by an integer) that tells why it's exiting. By convention, **zero indicates a normal or "successful" termination**.
- Before a dead process disappears completely, the kernel requires that its death be acknowledged by the process's parent, which the parent does with a call to `wait`. The parent receives a copy of the child's exit code (or if the child did not exit voluntarily, an indication of why it was killed) and can also obtain a summary of the child's resource use if it wishes.
- This process is typically great, but there can be problems if the parent doesn't outlive their child, or if the parent process doesn't call `wait` so that dead processes can be disposed of properly.
  - If a parent dies before its children, however, the kernel recognizes that no `wait` is forthcoming. The kernel adjusts the orphan process to make them children of `init` or `systemd`, which politely performs the `wait` needed to get rid of them when they die.

### Signals
- Signals are process-level interrupt requests. There are about thirty different kinds that are defined. They are used in a variety of ways:
  - They can be sent among processes as a means of communication.
  - They can be sent by the terminal drivel to kill, interrupt, or suspend processes when keys such as `<Control-C>` and `<Control-Z>` are pressed.
  - They can be sent by an administrator (with `kill`) to achieve various ends.
  - They can be sent by the kernel when a process commits an infraction such as division by zero.
  - They can be sent by the kernel to notify a process of an "interesting" condition such as the death of a child process or the availability of data on an I/O channel.
- When a signal is received, one of two things can happen. 
  - If the receiving process **has designated a handler routine** for that particular signal, the **handler is called with information about the context in which the signal was delivered**
  - Otherwise, **the kernel takes some default action on behalf of the process.** The default action varies from signal to signal.
- Specifying a handler routing for a signal is referred to as catching the signal. When the handler completes, execution restarts from the point at which the signal was received.
- To prevent signals from arriving, programs can request that they be either ignored or blocked. 
  - A signal that is ignored is simply discarded and has no effect on the process.
  - A blocked signal is queued for delivery, but the kernel doesn't require the process to act on it until the signal has been explicitly unblocked.
  - **The handler for a newly unblocked signal is called only once, even if the signal was received several times while reception was blocked.**

#### Common signals you need to be familiar with
|  #   | Name    | Description          | Default    | Can catch? | Can block? | Dump core? |
| :--: | ------- | -------------------- | ---------- | :--------: | :--------: | :--------: |
|  1   | `HUP`     | Hangup               | Terminate  | Yes        | Yes        | No         |
|  2   | `INT`     | Interrupt            | Terminate  | Yes        | Yes        | No         |
|  3   | `QUIT`    | Quit                 | Terminate  | Yes        | Yes        | Yes        |
|  9   | `KILL`    | Kill                 | Terminate  | No         | No         | No         |
|  10  | `BUS`     | Bus error            | Terminate  | Yes        | Yes        | Yes        |
|  11  | `SEGV`    | Segmentation fault   | Terminate  | Yes        | Yes        | Yes        |
|  15  | `TERM`    | Software Termination | Terminate  | Yes        | Yes        | No         |
|  17  | `STOP`    | Stop                 | Stop       | No         | No         | No         |
|  18  | `TSTP`    | Keyboard stop        | Stop       | Yes        | Yes        | No         |
|  19  | `CONT`    | Continue after stop  | Ignore     | Yes        | No         | No         |
|  28  | `WINCH`   | Window changed       | Ignore     | Yes        | Yes        | No         |
|  30  | `USR1`    | User-defined #1      | Terminate  | Yes        | Yes        | No         |
|  31  | `USR2`    | User-defined #2      | Terminate  | Yes        | Yes        | No         |
You should look at `man signal` to get more information.

#### Notable quirks about signals
- **The signals `KILL` and `STOP` cannot be caught, blocked, or ignored.**
  - `KILL` destroys the receiving process
  - `STOP` suspends its execution until a `CONT` signal is received (`CONT` can be caught or ignored, but not blocked)
- `TSPT` is a "soft" version of `STOP` that might be best described as a request to stop.
  - This signal is generated by the terminal driver when `<Control-Z>` is typed
  - Programs that catch this signal usually clean their state, then send themselves a `STOP` signal to complete the stop operation.
  - Alternatively, programs can ignore `TSPT` to prevent themselves from being stopped from the keyboard.
- `KILL`, `INT`, `TERM`, `HUP`, and `QUIT` all sound pretty much the same but do very different things.
  - `KILL` - unblockable and **terminates the process at the kernel level**, the process never actually receives or handles this signal, all the work is done by the kernel.
  - `INT` - sent by the terminal driver when the user presses `<Control-C>`. A request to terminate the current operation. Simple programs should simply quit. More complex programs that have interactive command lines should stop what they're doing, clean up, and wait for user input again.
  - `TERM` - a request to terminate execution completely. It's expected that the receiving process will clean up and its state and exit.
  - `HUP` - there are two common interpretations:
	- First, it's understood as a reset request by many daemons. If a daemon is capable of rereading its configuration file and adjusting to changes without restarting, a `HUP` can generally trigger this behavior.
	- Second, `HUP` signals are sometimes generated by the terminal driver in an attempt to "clean up" (i.e., kill) the process attached to a particular terminal. This behavior is largely a holdover from the days of wired terminals and modem connections.
  - `QUIT` - similar to `TERM`, except that it defaults to producing a core dump if not caught. A few programs cannibalize this signal and interpret it to mean something else.

### `kill`: send signals
- The `kill` command is most often used to terminate a process. `kill` can send any signal, but by default it sends a `TERM`
- `kill` can be used by normal users on their own processes or by root on any process.
- The syntax is:
```bash
kill [-signal] pid
```
where _signal_ is the number or symbolic name of the signal to be sent.
- A `kill` call without a number or symbolic name will **not** guarantee that the process will die. If the process fails to be killed you can use signal 9, but **you should only do this if the polite request fails**
- `killall` kills processes by name. For example, the following kills all Apache web server processes:
```bash
$ sudo killall httpd
```
- `pkill` searches for processes by name (or other attributes, such as EUID) and sends the specified signal.
```bash
$ sudo pkill -u bee
```

### Process and threaded states
- A process can be suspended with a `STOP` signal and returned to its active state with a `CONT` signal.
- Even when nominally runnable, threads must often wait for the kernel to complete some background work for them before they can continue execution.
- **A process is generally reported as "sleeping" when all its treads are asleep.**
  - Interactive shells and system daemons spend most of their time sleeping, waiting for terminal input or network connections.
  - A process that is sleeping generally receives no CUP-time unless it receives a signal or a response to one of its I/O requests.
- You might occasionally see "zombie" processes that have finished execution but have not yet had their status collected by their parent process (or by `init` or `systemd`). **If you see zombies hanging around, check their PPIDs with `ps` to find out where they're coming from.**

## `ps`: Monitor Processes
- the `ps` command is the system admin's main tool for monitoring processes.
- `ps` is closely tied to the kernel's handling of processes, so it tends to reflect all the vendor's underlying kernel changes.
- Note that Linux's `ps` is a little weird in that `ps -a` isn't the same as `ps a`
- The most important thing you need to know is `ps aux`
  - The `a` option says show all processes, the `x` says show even processes that don't have a control terminal, and `u` selects the "user oriented" output format that displays a little bit more useful information for a user than the default columns.
- Command names that appear in brackets aren't really commands, but rather kernel threads scheduled as processes.
- It is command to `grep` the output of `ps` get find the PID of a command:
```bash
$ ps aux | grep sshd
root  6811 0.0 0.0  78056 1340 ?     Ss 16:04 0:00 /usr/sbin/sshd
bee  13961 0.0 0.0 110408  868 pts/1 S+ 20:37 0:00 grep /usr/sbin/sshd
```
- Note that the `ps` output includes the `grep` command itself since it includes the desired text. You can remove this line using `grep -v`:
```bash
$ ps aux | grep -v grep | grep sshd
root  6811 0.0 0.0  78056 1340 ?     Ss 16:04 0:00 /usr/sbin/sshd
```
- You can also use `pidof` to retrieve PID of a process:
```bash
$ pidof /user/sbin/sshd
6811
```
- Or the `pgrep` utility:
```bash
$ pgrep sshd
6811
```
- The downside to these is that they show all processes that match the passed string. A simple `grep` is often much more flexible.
