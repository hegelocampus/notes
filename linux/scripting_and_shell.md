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
- With that said, its valuable to study some topics in detail.
