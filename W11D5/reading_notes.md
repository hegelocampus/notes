# Object-oriented JavaScript
#### JS Day 4
# Prototype inheritance
- objects get the functions constructed for them that have been constructed onto the prototype object of their parent
- When you make a new instance of an object it:
  - Creates that object
  - Adds all the values to the object contained in the constructor
  - looks at the methods that have been defined onto the object
- When you call something on an object JS searches up the chain looking for a matching function
  - First at the object
  - Then at the prototype of that object
  - Then at the prototype of the constructor of the object
  - Then at the parent object itself
  - Then at the parent's prototype
  - And so on
- You can set the prototype of an object point at a surrogate prototype
  - The below gives instances of `Dog` all of the functions that have been defined onto `Animal`
  - This is bad practice though because it was only implemented in ES2015 and is not supported by some shitty browsers that people still use for some reason
```javascript
Dog.prototype.__proto__ = Animal.prototype;
```
  - You can also get this behavior from `Object.setPrototypeOf(Dog.prototype, Animal.prototype);`
    - Although this will degrade the performance of all objects affected
	- Mutating the objects in anyway will also mess up the inheritance
  - **Best practice** is to create a brand new `prototype` object to use for creating the relationship
	- javascript created a brand new object with its `__proto__` set to whatever argument is passed to `Object.create`
```javascript
Dog.prototype = Object.create(Animal.prototype); // Dog now inherits from Animal
```
The only major limitation of this method is that the `Animal` constructor is not called whenever a dog is created. You can get around this by doing the following:
```javascript
function Dog (name, coatColor) {
  // call super-constructor function on **the current `Dog` instance**.
  Animal.call(this, name);

  // `Dog`-specific initialization
  this.coatColor = coatColor;
}
```
## Inheritance in ES2015
- Inheritance is much simpler
- You can use `class Dog extends Animal` to inherit the functions contained in Animal to Dog
- You can access a parent class's overwritten functions using `super`
  - To inherit the parent class's constructor you can do `super.methodName()`
## Using Modules is the Browser
- You can use `module.exports` and `require` to break up code into modules in node
  - **But this doesn't work in the browser**
- If we write front-end JS in multiple files you can explicitly list each of them in the HTML document
  - If any of the files you're adding requires another file the HTML doc **must** list the required file before the other file
- You gain access to multiple files through 'bundling' front end code into manageable modules
- Each file will explicitly require its dependencies at the top and then exports the object it is responsible for making
- This method is also beneficial because by only exporting the objects we want we protect the global namespace from pollution and name collisions
## Webpack
- If you set up your files as outlined above you can use webpack to bundle your files
- You can use `webpack app.js -o bundle.js --mode=development` to setup a bundle
  - This will search for the file named `app.js` and bundle any files it requires and all their dependencies
  - It will output to a file called `bundle.js`
  - Your html file should then require `bundle.js`
    - e.g., `<script src="bundle.js"></script>`
