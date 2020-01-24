# Middleware
- Middleware in redux specifically refers to an `enhancer` passed to the Store via `createStore()`
- When a `dispatch` is made the middleware intercepts the action before it reaches the `reducer`
- Middleware has the ability to:
  - **resolve the action itself**
  - **pass along the action**
  - **generate a side effect**
  - **send another dispatch**
  - or a combination of the above
- You can use `applyMiddleware` to pass in multiple middlewares
# Thunks
- Rather than returning a plain object, a thunk action creator return a function that can be called with an argument of `dispatch`
- This requires that middleware intercept all action of the type `function`, else everything would break
- Thunk middleware is avaliable as the `redux-thunk` library
## Namespacing
- A namespace is just a subset of controllers that live under a specific URL

