- When debugging fat arrow functions you need to convert then to have an explicit return
## Higher-Order Functions
- These are functions that operate on other functions
- Functions that are passed as parameters to and invoked in a higher-order function are known as callbacks.
### Composing Functions
- A function than composes two functions might look like the following:
```javascript
const compose = function (f, g) {
  return function (x) {
    return f(g(x));
  }
}
```
- This allows us to combine multiple functions into a single function and call them in tandem
