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
