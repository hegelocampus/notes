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
  - Container implementations use this feature to keep processes 
