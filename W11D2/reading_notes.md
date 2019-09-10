# Intro to JavaScript
## Context
- JS handles the way content is displayed on websites
- It makes websites much more versatile
  - It adds a ton of functionality
  - Allows for massive content changes without having to reload
- JS doesn't have classes and doesn't have integers (???)
  - Or maybe didn't
- Node is a server side implementation of JS
## JS examples
```javascript
function NBAPlayer(name, team, pos){ // This is called a constructor function
  this.name = name; // This here is acting kind of like 'self' would in ruby
  this.team = team;
  this.pos = pos;
  this.dunk = function(){}; // BAD
  /* If you place the function definition here then the entire function will be redefined onto them when they are created, its DRY-er to define repeated methods onto prototypes */
}

const curry = new NBAPlayer(); 

NBAPlayer.prototype.dunk = function(){/*Function def would go here*/};

curry.dunk(); // You can now do "Method Style" calls of this

curry__proto__ === NBAPlayer.prototype
```
- **Every JS function has a prototype defined onto them**
  - You use this to define new methods
- Don't define functions for functions in the function itself, its not DRY and bad
  - These are called nested functions
- The better way to define functions is to define them on the prototype created by the function
  - If there is a function defined within the main function then it will override any function defined on a prototype
## Closures and callbacks
- Scope in JS
  - arguments passed into functions are always in the scope of a function
  - a function has access to any variable that is defined before the function is called
  - You can use a function within the definition of a function to define a variable in a flexible way
  - You can set a function to have global scope using `global` in the function definition
  e.g.,
  ```javascript
  global.setTimeout(function() {
    console.log("It has been 5 seconds!");
  }, 5000); // THIS IS THE ES5 way of doing this, VERY old now

  // ES6
  global.setTimeout(() => {
    console.log("It has been 5 seconds");
  }, 5000);
  // ^^ preferred syntax
  ```
## Debugging JS
- You can drop a breakpoint at any point in the code in VS Code by right clicking in the margin on the line where you would like to add a breakpoint
  - You can add conditional breakpoints too
- If you want to see the value of a variable you can watch it by clicking the `+` in the `WATCH` section
## Running JS
- You can run JS in node really easily, it works just like ruby
## General Syntax Stuff
- **Every expression needs a semi-colon at the end**
  - Statements don't generally require semi-colons
- Curly braces are used to delineate code blocks
`for` Loops look like this:
```javascript
for (let i = 0; i < 10; i++) {
  //Just like C++
}
```
`while` loops look like this:
```javascript
while (condition) {
  //This is pretty typical
}
```
### Looping keywords
`continue` skips the current iteration  
`break` exits the loop  
## Switch statements
```javascript
switch (expression {
  case x:
    //pretty similar to ruby
    break;
  case y:
    //yee
	break;
  default:
  // This bit is new
}
```
`console.log` is the `puts` of JS
## Falsey vs. Truthy
In JS, zeros, empty strings, undefined, null, and `NaN` are all falsey values
## Declaration
- Gotta declare those variables and constants, like C++
  - use the `var` keyword to do that: `var myVar;`
- You can use `let` to declare **block-scoped variables**
  - These are only accessible from within the block (not the entire function)
- You can use `const` to declare constants
  - JS will raise an error if you try to redefine constants
  - The object itself is not immutable, only the binding is immutable
