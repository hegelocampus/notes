# Currying
- This is chaining a function take in different values and then using all of the variables in the most nested function
  - This works because of closure, so all functions have access to the vars within the scope of their definition
- This is **not** recursion, it returns the new method without calling it
  - This is why these methods have closure over the vars they need to function
  - Curried functions still need to be invoked in order to get a value
```javascript
function addThreeNums (num1, num2, num3) {
  return num1 + num2 + num3;
}

function curriedAddThreeNums() {
  return function (num1) {
    num1;
	return function (num2) {
	  num1, num2;
	  return function (num3) {
	    return num1 + num2 + num3;
	  }
	}
  }
}

curriedAddThreeNums()(1)(2)(3);

function curriedSum(numArgs) {
  const nums = []; // create an array to hold all the inputted nums

  return function _curriedSum(num) {
    nums.push(num);
	if (nums.length === numArgs) {
	  let result = 0;
	  nums.forEach(num => result += num);
	  return result;
	} else {
	  return _curriedSum;
	}
  }
}

const curriedAdd = curriedSum(3); // This is the num of inputted nums
curriedAdd(1)(2)(3); // This is the input of the actual numbers that will be added together
```
## Prototypal Inheritance
- You shouldn't set the `__proto__` property yourself and should use the built in functions
- There are a few ways to deal with this
  - Create a new empty class to act as the prototype for a class
  - Make sure you do the prototype assignment before you do any definitions on the prototype class
**The following four lines of code will be on the assessment**
```javascript
function makeInheritanceChain (Parent, Child) {
  function Surrogate () {};
  Surrogate.prototype = Parent.prototype;
  Child.prototype = new Surrogate(); // This replaces the Dog's prototype with the surrogate one
  Child.prototype.constructor = Child;
}
// This correctly sets the constructor to be the dog constructor without disrupting the Animal class's prototype
```
ES5 introduced the following (much easier) way to do this:
```javascript
Object.create

```
Visualization;
```                     
						Dog.prototype
lola                    (new Surrogate)				Animal.prototype
{                       {							{
name: 'lola',           bark: function () {},		  eat: function () {},
  favoriteToy: 'frog',    __proto__: -->			  constructor: Animal
  __proto__: -->          constructor: Dog			  __proto__: Object
}						}
```
## Canvas
- Canvas can use the graphics card on the computer to greatly improve performance
- In order to make something seem like a video you have to replace a drawn image with a newly drawn image
  - To do that you have to clear the previous image
