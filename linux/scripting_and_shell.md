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
Any well-behaved command that reads STDIN and writes STDOUT can be used as a filter (that is, a component of a pipeline) to process data.
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
- `grep` - Search text
  - This is a fairly simple implantation of regular expressions, if you need more power you should use Ruby or Python

## sh Scripting
- `sh` is great for simple scripts that automate things you'd otherwise be typing on the command line.
- Once an `sh` script gets above 50 lines or so, or when you need features that `sh` doesn't have, its time to move to Python or Ruby.

### Execution
- `sh` comments start with a sharp (`#`) and continue until the end of the line.
- The first line of a `sh` script is know as the "shebang" statement and declares the text file to be a script for interpretation by `/bin/sh` (which might itself link to `dash` or `bash`)
  - If you need your script to run under `bash` or another interpreter that might not have the same command path on every system, you can use `/usr/bin/env` to search your `PATH` environment variable for a particular command, e.g., `#!/usr/bin/env ruby`
- To prepare a script for running, you just need to turn on its execute bit
```bash
$ chmod +x helloworld
$ ./helloworld
Hello, world!
```
- You can also invoke the shell as an interpreter directly:
```bash
$ sh helloworld
Hello, world!
$ source helloworld
Hello, world!
```
- The first command here runs `helloworld` in a new instance of `sh`, the second makes your existing login shell read and executer the contents of the file.
- Good approach for developing `sh` scripts
  - Develop the script as a pipeline, one step at a time, entirely on the command line. Use `bash` for this process even though the eventual interpreter might be `dash` or another `sh` variant.
  - Send output to standard output (using `echo`) and check to be sure it looks right.
  - At each step, use the shell's command history to recall pipelines and the shell's editing features to tweak them.
  - Until the output looks right, you haven't actually done anything, so there's nothing to undo if the command is incorrect.
  - Once the output is correct, execute the actual commands and verify that they worked as you intended
  - Use `fc` to capture your work, then clean it up and save it.

### Input and output
- The `echo` command is crude but easy. For more control over your output, use `printf` instead.

### Spaces in filenames
- Unfortunately filenames are often riddled with spaces. Legacy software tends to break when spaces appear in filenames because spaces are bad, but you (and your scripts) need to be prepared for dealing with them.
- In the shell and in scripts, spaceful filenames can be quoted to keep their pieces together.
- You can also escape individual spaces with a backslash
	
### Command-line arguments and functions
- When command-line arguments are passed to a script, they become variables whose names are numbers. `$1` is the first command-line argument, `$2` is the second , and so on. 
- `$0` is the name by which the script was invoked.
- `$#` contains the number of command-line arguments that are supplied.
- `$*` contains all the arguments at once.
- If you call a script without arguments or with inappropriate arguments, the script should print a short usage message to remind you how to use it.
  - If the arguments are invalid, the script should also throw a nonzero exit code, indicating failure.
- Arguments to `sh` functions are also treated like command-line arguments.

### Control flow
- Here's an if statement, note it begins with `if`, ends with `fi`, and `elif` is used for else if blocks
```bash
if [ $base -eq 1 ] && [ $dm -eq 1]; then
  installDMBase
elif [ $base -ne 1 ] && [ $dm -eq 1]; then
  installBase
elif [ $base -eq 1 ] && [ $dm -ne 1]; then
  installDM
else
  echo '==> Installing nothing'
fi
```
- The brackets are actually a shorthand way of invoking `test` and aren't actually required, although they are frequently used. (It isn't actually technically true that they just run `(/bin/test` if you are using a modern shell, they are actually just built in, but this _is_ how it used to be)

#### Elementary sh comparison operators
String  | Numeric | True if
------- | ------- | -------
`x = y`   | `x -eq y` | x is equal to y
`x != y`  | `x -nq y` | x is not equal to y
`x < y`   | `x -lt y` | x is less than y (**The `<` must be backslash-escaped to prevent being interpreted as an input or output redirection**)
n/a     | `x -le y` | x is less than or equal to y
`x > y`   | `x -gt y` | x is greater than y (**The `>` must be backslash-escaped to prevent being interpreted as an input or output redirection**)
n/a     | `x -ge y` | x is greater than or equal to y
`-n x`    | n/a     | x is not null
`-z x`    | n/a     | x is null

- `sh` is fantastic in its operations for evaluating the properties for files
#### `sh` file evaluation operators
| Operator         | True if
| ---------------  | -------
| `-d file`          | file exists and is a directory
| `-e file`          | file exists
| `-f file`          | file exists and is a regular file
| `-r file`          | User has read permission on file
| `-s file`          | file exists and is not empty
| `-w file`          | User has read permission on file
| `file1 -nt file2`  | `file1` is newer than `file2`
| `file1 -ot file2`  | `file1` is older than `file2`

- `case` is often used over `elif` for clarity
  - Of note is the closing parenthesis after each condition and the two semicolons that follow the statement block to be executed when a condition is met.
```bash
case $message_level in
  0) message_level_text="Error" ;;
  1) message_level_text="Warning" ;;
  2) message_level_text="Info" ;;
  3) message_level_text="Debug" ;;
  *) message_level_text="Other" 
esac
```

### Loops
- `sh`'s `for...in` construction is great for working on groups of values or files, especially when combined with filename globbing.

```bash
#!/bin/sh

suffix=BACKUP--`date + %Y-%m-%d-%H%M`

for script in *.sh; do
  newname="$script.$suffix"
  echo "Copying $script to $newname..."
  cp -p $script $newname
done
```
- Any whitespace-separated list of things can be the target of `for...in`
- `bash`, but not vanilla `sh`, also has a more familiar `for` loop structure from traditional programming languages in which you specify starting, increment, and termination clauses.
```bash
# bash-specific
for (( i=0 ; i < $CPU_COUNT ; i++ )); do
  CPU_LIST="$CPU_LIST $i"
done
```
- `sh` also has `while` loops

### Arithmetic
- All `sh` variables are string valued, so `sh` does not distinguish between the number 1 and the character string "1" in assignments.
- You can use `$((foo + bar))` to force numeric evaluation.
