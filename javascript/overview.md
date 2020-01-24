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
# JS lecture notes
- Strings are immutable in JS
  - They are basically symbols in ruby
- Arrays are mutable and JS won't say that two arrays that contain identical values are the same
  - e.g., [1,2] === [1,2] => false
- There's a lot of syntastic sugar in ruby you can't use in JS
- Use camel case in JS
- Arrays have a key/value thing that is similar to hashes in ruby
## Functions
- You can use back-ticks for string interpolation
```javascript
const person = {
  name: "Bee",
  sayHi Function {
	console.log(`${ this.name } says hi!`); // This here refers to the person
  }
};
```
- You can bracket into any JS object
- All objects within a class shore the same prototype attribute that can be used to store functions
  - Can this be used to store class instance variables?
- Javascript doesn't have argument errors, you can pass any amount of variables into any argument
- If you don't explicitly return something then your function will return `undefined`
## `this`
- `this` is the self tag of JS
- You can use this to define an attribute of an object from within the object
- This has different scope in function style, method style and constructor style
	- **In function style it is always the global scope**
## Method style
```javascript
person.sayHi() // Method style is called on an object
// If there is a dot in front of the function call then it will always be a method call
```
### Function style
```javascript
let mySayHi = person.sayHi;
mySayHi()
```
## Constructor Style
```javascript
new mySayHi();

```
## Code example
```javascript
function Cat() { // uppercase denotes class
  this.name = "Sennacy";
  this.meow = function () {
    console.log(`${ this.name } says meow`)
  }
  // If you define functions this way the function gets redefined each time you create a new instance of this class
};

// its better practice to use the prototype property
Cat.prototype.meow = function () {
  console.log(`${ this.name } says meow`);
};

// Fat arrow functions
const other Func = () => {
  // Fat arrow function
};
const anotherFunct = () => 5;
// 5 return here without an explicit return because its not in curly braces

```
### Fat arrow functions
- Fat arrow functions capture the scope in which they are created
  - This means that they will always have access to the variables that they have avaliable when they are defined
- Fat arrow functions don't play well with prototypes
  - This is because of how they take in the scope in which they are defined, so `this` will be defined in the global scope and will not refer to the object itself
## Hoisting
- Causing variables to act like defined variables before they are actually defined
  - If a variable is defined later than it is used then JS will pull the variable definition to before the place where it is needed
  - This even works for named functions
- This is useful to know about because it used to be popular to do all function definitions at the bottom of the file, so you may occasionally encounter files that are styled like that
- We won't be using this a lot because this is no longer seen as being best practice
```javascript
let favFood = Taco;
if (true) {
  console.log(favFood);
  let favFood = 'Pizza';
  console.log(favFood);
}
console.log(favFood);
```
## Closures
- When a function is defined it closes over all the variables that were avaliable at definition
```javascript
function dinerBreakfast() {
  const order = "I'd like cheesy scrambled eggs";

  return function  {
    return order;
  };
}
```
## Callbacks
- Passing a function as the argument for another function
- A callback calls us back through the function that is passed in
- You can pass unnamed functions directly into other functions or passing in a function saved as a variable
  - The function only has access to the variables in its scope **when it was defined**
```javascript
const a = [1, 2, 3, 4, 5];

a.forEach(function(el) {
  console.log(el);
});

const myCb = function (el) {
  console.log(el);
};
a.forEach(myCb) // This is where the myCb is actually called

const each = function (arr, cb) {
  for (let i = 0; i < arr.length; i++) {
    const el = arr[i];
  }
}

each(a, function (el) {
  console.log(el);
});

each(a, myCb);
```
## Monkey patching
- You can monkey patch onto the prototype of any object
e.g.,
```javascript
Array.prototype.first = function() this[0];
[1, 2, 3].first;// => 1
```
## Array construction
- in JS you have to do `Array.from` to generate an array with filled with unique values
```javascript
uniqArr = Array.from(
  { length: 3 }
  (i) => {
    return [];
  }
);
```
