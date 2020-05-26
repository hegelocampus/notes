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
| # | Name | Description | Default | Can catch? | Can block? | Dump core? |
