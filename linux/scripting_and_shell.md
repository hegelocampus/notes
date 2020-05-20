# Scripting and the Shell
- Scripts standardize administrative chores and free up admins' time for more important and interesting tasks.
- Scripts also serve as a kind of low-rent documentation in that they record the steps needed to complete a particular task.

## Scripting Philosophy
### Write microscripts
- You achieve most efficiencies by saving a few keystrokes here and a few commands there.
- **As a general rule, approach every chore with the question, "How can I avoid having to deal with this issue again in the future?"**
- Most admins keep a selection of short scripts for personal use (aka scriptlets) in their `~/bin` directories.
  - This type of script should be used to address the pain points you encounter in day-to-day work.
- You can also define shell functions for this purpose as well.
  - These are scripts that live in the shell configuration files. 
  - These are independent of your path and travel with you wherever you take your shell environment.
  - The main disadvantage of shell functions is that they're stored in memory and have to be reparsed every time you start a new shell, but this cost is typically negligible if you're using modern hardware.
- For ultra small scale tasks you should use aliases, which are really just an extra short-variety of scriptlet.
  - These can be defined either with shell functions or with your shell's built-in aliasing feature.
  - Most commonly used for setting default arguments for individual commands.

### Learn a few tools well
- You will encounter a lot of software. You can't be an expert at everything, so its good to become skilled at skimming documentation, running experiments, and learning just enough about new software packages to configure them for the local environment.
- With that said, its valuable to study some topics in detail. In particular, you should know the following throughly:
  - A shell
  - A text editor
  - A scripting language

### Automate everything
- Shell scripts aren't always your best opportunity to benefit from automation. There are a ton of programmable systems out their and you should exploit them aggressively and use them to impedance-match your tools to your workflow.

### Don't optimize prematurely
- Optimization can have amazingly low return on investment, even for scripts that you run regularly out of `cron`
- Be smart about spending extra time to optimize tasks, it may be a waste of time.

### Pick the right scripting language
- For a long time, the standard language for admin scripts was the one defined by the `sh` shell. 
  - Shell scripts can typically be used for light tasks such as automating a sequence of commands or assembling several filters to process data.
  - The shell is always available, so shell scripts are relatively portable and have few dependencies other than the commands they invoke.
- JavaScript and PHP are best know for web development, but can be arm-twisted into service as general-purpose scripting tools, too.
  - You probably shouldn't try to use JS or PHP for system admin tasks.
  - In fact you probably shouldn't try to use PHP for anything.
- Python and Ruby are modern, general-purpose programming languages that are both well suited for system admin work.
  - These languages incorporate decades' worth of language design advancements relative to the shell, and their text processing facilities are incredibly powerful.
  - Their main drawback is that their environment can be fussy to set up, especially if you need to use third-party libraries that have components written in C.

## Shell Basics
- UNIX has always offered users a choice of shells, but some version of the Bourne shell, `sh`, has been standard on every UNIX and Linux system.
- `sh` is most commonly manifested in the from of the Almquist shell (known as the `ash`, `dash`, or simply `sh`) or the "Bourne-again" shell, `bash`.
- `bash` focuses on interactive usability
  - It still runs scripts designed for the original Bourne shell, but it's not particularly tuned for scripting.
  - Some systems include both `bash` and `dash`, others rely exclusively on `bash`
- There are various offshoots of `bash` notably `ksh` (the Korn shell) and `ksh`'s souped-up cousin `zsh`
  - `zsh` features broad compatibility with `sh`, `ksh`, and `bash`
  - `zsh` also includes a ton of extra features and its great and the best thing ever and I love it.
  - The book says it's not used as any systems default shell, but that's wrong now because iOS uses `zsh` by default now.

### Pipes and redirection
- Every process has at least three communication channels available to it:
  - Standard input (STDIN)
  - Standard output (STDOUT)
  - Standard error (STDERR)
- These channels are initially inherited from the process's peer, so they don't necessarily know where they lead.
- These channels could connect to the following:
  - A terminal window
  - A file
  - A network connection
  - A channel belonging to another process
  - Many many more
- UNIX and Linux have a unified I/O model in which each channel is named with a small integer called a **file descriptor**.
  - The exact number assigned to a channel is not typically significant.
  - STDIN, STDOUT, and STDERR are guaranteed to correspond to the file descriptors 0, 1, and 2
- The shell interprets the symbols `<`, `>`, and `>>` as instructions to reroute a command's input or output to or from a file.
  - A `<` symbol connects the command's STDIN to the contents of an existing file.
  - The `>` and `>>` symbols redirect STDOUT
	- `>` replaces the file's existing contents
	- `>>` appends to them.
- You can use the `>&` symbol to redirect both STDOUT and STD error to the same place.
- You can use `2>` to just redirect STDERR.
- You can use `&&` to execute a second command only if is precursor **completes successfully**.
- You can use `||` to execute a second command only if ts precursor **fails** (that is, produces a nonzero exit status).

### Variables and quoting
- Variable names are unmarked in _assignments_ but prefixed with a dollar sign when their values are _referenced_
```bash
$ etcdir='/etc'
$ echo $etcdir
```
- **Make sure to omit spaces around the = symbol**; otherwise, the shell mistakes your variable name for a command tame and treats the rest of the line as a series of arguments to that command.
- When referencing a variable, you can surround its name with curly braces to clarify to the parser and to human readers where the variable name stops and other text begins; for example `${etcdir}` instead of just `$etcdir`
  - The braces are not normally required, but are best practice and are useful if you want to expand variables inside double-quoted strings.
- There is no standard convention for naming shell variables, but all-caps names typically suggest environment variables or variables read from global configuration files.
- The shell treats strings enclosed in single and double quotes similarity, except that **double-quoted strings are subject to globbing and variable expansion**
	
### Environment variables
- When a UNIX process starts up, it receives a list of command-line arguments and also a set of **environment variables**.
- You can view your current environment variables using the `printenv` command.
- Programs that you run can consult these variables and change their behavior accordingly. For example, `vipw` consults the `EDITOR` environment variable to determine which text editor to run for you.
- You can use `export varname` to promote a shell variable to an environment variable. You can also combine this syntax with a value assignment:
```bash
$ export EDITOR=nvim
$ vipw
<starts the nvim editor>
```
- Although these are called "environment" variables, the values don't exist in some abstract place. Rather the shell simply passes a snapshot of the current values to any program you run.
  - Because of this every shell, program, and terminal window has its own distinct copy of the environment that can be modified separately

### Common filter commands
- Any well-behaved command that reads STDIN and writes STDOUT can be used as a filter (that is, a component of a pipeline) to process data.
- `cut` - separate lines into fields
  - The `cut` command prints selected portions of its input lines. It most commonly extracts delimited fields, and it can also return segments defined by column boundaries.
  - The default delimiter is <Tab>, but you can change delimiters with the `-d` option. The `-f` options specifies which fields to include in the output.
- `sort` - sort lines
  - The `sort` command sorts its input lines.
  - There are multiple sorting options and its probably a good idea to look at the manual to see what you need.
- `uniq` - print unique lines
  - `uniq` is similar to `sort -u`, but it has some useful options that `sort` doesn't emulate: `-c` to count the number of instance of each line, `-d` to show only duplicated lines, and `-u` to show only nonduplicated lines.
  - The input must be presorted, usually by being run through `sort`
```bash
$ cut -d: -f7 /etc/passwd | sort | uniq - c
```
- `wc` - count lines, words, and characters
  - Counts the number of lines, words, and characters in a file.
  - Run without options it displays all three counts, but you can use the `-l`, `-w`, or `-c` flags to make `wc`'s output consist of a single number.
- `tee` - copy input to two places
  - Great for tapping into a data stream to copy to a file or the terminal window.
- `head` and `tail` - Read the beginning or end of a file
  - You can use `-n` to pass the number of lines you want.
  - For interactive use, `head` has been made obsolete by `less`
