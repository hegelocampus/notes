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
