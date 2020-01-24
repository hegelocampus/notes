- AJAX requests will be the only interface from frontend to backend (and JSON from the backend to the frontend)
# Middleware
- The `enhancer` is the redux middleware
- It is taken in as an argument of `createStore`
- `applyMiddleware` is expecting a function that is three levels deep
- The next function is always the next function in the chain
  - This must be invoked in order to successfully chain middleware component
- `applyMiddleware` calls the last middleware first, which calls the next middleware, which calls the next, and so on
# Thunk
- Dispatches functions rather than POJOs
  - These functions run the action which returns the actual POJO that can be sent into the dispatcher
- Thunk will have access to the store
- Thunk will check if the dispatched obj is a function and if it is it will invoke it and send in the return as the parameter of the dispatcher
  - The thunk should have a `then` call to invoke the next action
  - This function can be an api call, for example
  - If it isn't a function it will just send the argument into the dispatcher like normal
- You can add a thunk to simulate latency
- Theres a lot of nested functions in here, the way Tommy explains it is pretty confusing but I'm not 100% convinced its actually that hard to understand
  - I think the main takeaway is that you can setup your dispatch to accept functions by injecting middleware that intercepts the function, calls it, and then sends the return of that function into the dispatch
- This pattern allows you to write dryer code by combining the actions of multiple dispatchers that perform similar actions
  - This is essentially just a pattern that you're going to have to memorize
- Make sure you return everything in the thunk action
  - Its very common to forget to return in this function
## Action Types
- A thunk action returns a function
- A regular action return a POJO
