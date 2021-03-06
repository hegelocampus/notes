# Redux Fundamentals

## Store
- Store holds the global state
- It is responsible for:
  - updating the app's state via its **reducer**
  - broadcasting the state via **subscription**
  - listening for **actions** that tell it how and when to change the global state
## Creating the Store
- `createStore()` to create the store
  - It takes up to three args and returns a Redux `store`
	- `reducer` (required) - A reducing function that receives the app's current state and incoming actions, determines how to update the store's state, and returns the next state (more on this in a moment).
    - `preLoadedState` (optional) - An object representing any application state that existed before the store was created.
    - `enhancer` (optional) - A function that adds extra functionality to the store.
For example:
```javascript
// store.js
import { createStore } from `redux`;
import reducer from './reducer.js';

const store = createStore(reducer);
```  
## Updating the Store
- Store updates can only be triggered by dispatching **actions**
- The **action** defines the **type**
- The action is routed sent to the **reducer** that routes the information and produces the next state
Example reducer:
```javascript
// reducer.js
const reducer = (state = [], action) => {
  switch (action.type) {
    case "ADD_FRUIT":
      return [...state, action.fruit];
    default:
      return state;
  }
};

export default reducer;
```
- Note that in Redux **the state is immutable** so the reducer must **return a new array or object** if state is to change
  - You can use `Object.freeze()` to ensure that the state isn't accidentally mutated
	- You should do this at the top of every reducer you write
## Subscribing to the Store
- Once the store has processed a **dispatch** all of its subscribers are triggered
  - These subscribers are callbacks that can be added to the store via `subscribe()`
## Reducers
- Reducers can delegate actions to subordinate reducers
## Actions
- Actions are simple POJOs with mandatory `type` keys and optional payload keys
## `react-redux`
- This package gives us bindings that simplify the most common React-Redux interactions
  - For example, it allows you to circumvent **prop-threading** 
# Setup
- Use `npm install --save react-redux` to add react-redux to a project
- Then import it using `import { Provider } from 'react-redux';`
## Provider: Setting `context`
- You can use `Provider` to pass the store to deeply nested components without threading
- This will require you to create a `Root` component that takes `store` as an argument and wraps the `App` component with the `Provider` component
e.g.,
```javascript
// root.jsx
import React from 'react';
import { Provider } from 'react-redux';
import App from './app.jsx';

const Root = ({ store }) => (
  <Provider store={store}>
    <App />
  </Provider>
);

export default Root;
```
- This `Root` component will pass the store to all its nested components
  - Components that need to access the store context can then use `connect` to convert the `store` context into a `store` prop
## Connect()
- `connect()` takes two arguments and returns a function
e.g.,
```javascript
const createConnectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
);
```
- The first argument passed is `mapStateToProps`
  - it tells `connect()` how to map the `state` to the component's `props`
  - it takes the store's `state` as an argument and returns a new object
## Containers
- A common pattern in redux is to separate the **presentational components** from the **containers**
  - The containers contain all the logic pertaining to the management of data
	- The containers are typically the part that is subscribed to the Redux state
	- They are generated by `React-Redux connect()`
  - The presentational components are purely concerned with rendering the page itself
- You generally only want to create containers for the 'big' components
  - In general aim to have fewer containers rather than more
