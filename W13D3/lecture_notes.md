#Week 13 Day 3: Lecture notes
## Redux
- An action is just an object with an attribute of type
### Reducers
- The reducers return a new state and delegate the actual modification of the state to the correct subcomponent-reducer
- Its convention to build the reducer as a switch with a default case that just returns state
e.g.,
```javascript
const rootReducer = (state = {}, action) => {
  case (action.type) {
	case "ADD_FOO":
	  // Do some actual things and return a new state object
    default:
	  return state;
  }
}
```
- **Combined reducers** invoke the action of another reducer
  - i.e., delegate the state change to another reducer
- Its convention to use constants as the action type
  - You will need to need to export the constants if you want to use them in multiple files
- Its good to get in the habit of **freezing** the state at the top of the reducer to ensure it isn't accidentally changed
### react-redux
- This provides us with a `Provider` component that will handle the store, you can wrap anything that needs access to the store in a `<Provider>` tag within the jsx in the return
- You will need to either create a container component to do the state interaction for the component, or have the state interaction actually being done by the component
- The component will use `connect` to interface with the global state
  - This takes two arguments:
	- `mapStateToProps`: returns the desired relationship between the state value by connecting it to the props key
	- `mapDispatchToProps`
  - This is essentially just merging the state and dispatch with the props, it really isn't as complicated as they're making it sound
