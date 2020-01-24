## The Event loop
### Ways to call a function
- Function-style `fun(arg1, arg2)`
  - `this` is global
  - Call backs are almost always called in this style 
  - You can use arrow functions to make function-style calls to use the objects scope
- Method-style `obj.method(arg1, arg2)`
  - `this` is set to `obj`
- constructor-style `new ClassName(arg1, arg2)`
  - Creates a new object, this is one way to set up classes
  - `this` is set to the blank object
### Less common ways
#### Apply
`Function.prototype.apply`
- Takes two arguments
  - an object to bind `this` to
  - an array of arguments to be passed to the method apply is being called on
- This allows you to call a function and give it access to variables that would have been outside of its scope
#### Call
- Very similar to apply but in taking in an array of params it takes in them individually
## Intro to Callbacks: File I/O
### A callback is a function that is passed to another function as an argument
- A closure is a callback that uses outside variables
### JS is Asynchronous
- An **asynchronous** function doesn't wait for work to be completed, it schedules work to be done in the background
- Asynchronous functions tend to be used when work may take a variable amount of time:
  - Timers
  - Background web requests (AJAX)
  - Events
- The flip side of this is **synchronous** functions
  - Ruby's `sleep` method is an example of a synchronous function
  - These functions always take the same amount of time to run
### Node I/O is Asynchronous
- JS's version of `puts` and `gets` are `console.log` and `prompt` and `readline`
  - `prompt` will open a pop up message box to ask the user for input
	- It is not avaliable when running in the node.js environment
  - `readline` will ask for user input more like `gets`
	- `readline` comes with a `question` method that can prompt the user for input
	- `question` is asynchronous and will not wait for input and return immediately
	- It is only after the user has inputted a response that the callback is called
**Asynchronous functions do not return meaningful values: we give them a callback so that the result of the async operation can be communicated back to us**  
  - If we want to stop accepting input we have to explicitly call 'reader.close()'
## Classes
- There is a newer way to create classes, that was introduced with ES2015, that allows for classes to be created in a way that is much more familiar
```javascript
class Bicycle {
  consructor(model, color) {
    this.model = model;
	this.color = color;
  }

  action() { // This is a prototype method (instance method)
    return "rolls along";
  }

  static parade() { //This is similar to a class method
  }
}
```
## Node Module Pattern
- Node modules allow you to split up your code into different files
- They work differently than ruby
- You have to name an object to hold the value of the imported object
```javascript
// ./cat.js
class cat {
}
module.exports = Cat;
// ./dog.js
class dog {
}
module.exports = Dog;
// ./animals.js
const Cat = require("./cat");
const Dog = require("./dog"
const cat = new Cat();
const dog = new Dog();
```
- Normally required files will import classes
- Node's require doesn't import the module's global scope
**You will need to set require to a variable and access that variable to access the module**  
### Importing multiple classes into one file
- You can do this by pointing `require` at a directory
- This file will need an index to tell the importing file the files it needs to look for and where they are
- This will then be assigned to a variable in the importing file
  - This variable is called a **namespace**

