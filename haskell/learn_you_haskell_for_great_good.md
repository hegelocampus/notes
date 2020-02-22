# Learn You Haskell for Great Good
## Intro
### What's Haskell?
*Haskell is a Purely functional programming language*  
This is defined through negation
- Imperative languages
  - Complete tasks through giving the computer a sequence of tasks and then executing them.
  - While executing them it can change state. E.g., you can set variable `a` to one thing and then at a later point set it to something else.
  - You have structures to control how many times an action is performed.
- Functional languages
  - You don't tell the computer what to do, but rather tell it what stuff _is_.
    - For example, a factorial is the product of all the numbers form 1 to that number, the sum of a list of numbers is the first number plus the sum of the rest of the list.
    - You express these definitions in the form of a function.
  - You can't set a variable to something and then change it later.
  - A function has no side effects, none of the input values are ever changed.
  - All a function does is calculate something and return it as a result.
  - **Referential Transparency: If you call a function twice with the same parameters you're guaranteed to get the same result**
What Haskell is:
- Lazy
  - It won't execute functions unless you force it to tell you a result.
  - This allows you to think of functions are a series of transformations on data.
  - Allows for infinite data structures.
  - Only passes through the data when it actually needs to, allowing for reduced time complexity.
- Statically typed
  - The compiler knows which pieces of the code are what data types.
  - A lot of possible errors are caught at compile.
  - Has *type inference*. So you don't have to explicitly label every variable.
- Elegant and concise
  - Programs are usually shorter than their imperative equivalents.
  - Shorter programs are easier to maintain and have less bugs.
Haskell Platform
- GHC is the most widely used Haskell compiler.
  - Interactive mode using `ghci`
  - Load a file using `:l foo` in the directory containing `foo.hs`. Run the command again if you change the file or do`:r`
