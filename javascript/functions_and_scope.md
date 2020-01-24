- Constructor style
  - This is a new empty object
- Method style
  - This is the thing you call the method on
- Function Style
  - This is the global object
- You can use the spread operator like you would use the splat operator in ruby
## Call & Apply
- You can use `call` and `apply` to change the context of a method
- `call`
  - The first argument is the this keyword of the function
  - All subsequent arguments are passed into the argument
  - You can also send in the needed keys using a hash
- Call and apply invoke the function right away, the context can't be saved to a variable
```javascript
const sniff = Dog.prototype.sniffPerson;
sniff.call({name: "Toto"}, "Tommy");
```
## Bind
- You can save `this` to another variable to bind this in order to use it within a context where `this` would be different
```javascript
const that = this;
```
- You can use `bind` to overwrite the default `this` within a function
- Bind can be appended onto the end of the functions definition
- Fat arrow functions use bind by default, if you try to do this on fat arrow functions it will have no effect
- Always bind callback functions if you want to retain the context
  - E.g., `map` and `forEach`
```javascript
const the Cb = function(person) {
  this.snifPerson(person);
}.bind(this);
```
## Asynchronous Behavior
- JS doesn't run code in the order it is in the file
  - This means it won't wait for user input to start running the rest of the code unless you explicitly make it do so
- Any code you want to run after the answer form the user should be after the callback
# Evening lecture
- `...arg` can be used like the splat operator in ruby to pass in an array of values as arguments
- We will get either `myCall`, `myBind`, or `my{ thirdOne }`
- Anything that was on A01 is also fair game
- These won't be on the assessment:
  - Debounce is useful for delaying delay until after the user is done typing
  - Throttling is useful for restricting the use of expensive functions
	- It guarantees that you will never call the function more than a certain number of times per interval
	- This doesn't have a lot of front end uses, its more of a back end thing
