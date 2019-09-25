# Week 13 Day 1
## React
- React is a lot faster than vanilla JS because it allows for changes to be made without requiring a bunch of small changes
  - i.e., it repaints everything that needs to be changed all at the same time, within a batch
- Babel translates all the weird jsx syntax into plain javascript curly braces in jsx html tags will tell jsx to read whats in the braces as javascript
  - Its good practice to wrap the jsx html in parenthesis so that you can break a line and indent the block so it looks more like html
- You can use fat-arrow syntax with parenthesis to implicitly return multiple lines
- Children don't have access to the props of their parents
  - This is an easy mistake to make because it seems like these two objects should share the same context but they are actually completely different functions with different contexts

## Creating a new react project
- Webpack config: 
  - You should add `resolve: { extensions: ['.js', '.jsx', '*'] }` and a bunch of module info
- `package.json` config:
  - You will have to declare the main JS file here
- You will have to import the `ReactDOM from 'react-dom'` and `React from 'react'` into the `entry.js`
- The entry will add an event listener and within that you can render anything you want using `ReactDOM.render(foo, root)`
 
e.g., 
```javascript
// ./entry.jsx
import ReactDOM from 'react-dom';
import React from 'react';
import App from './app';

document.addEventListener"DOM ContentLoaded", function () {
  const root = document.getElemntById("root");

  //const article = React.createElement(
  //  "article",
  //  null, //This is a prop
  //  [
  //    React.createElemnt("p", null, ["Hello from the first paragraph"])
  //  ]
  //)
  //// This can be translated into jsx
  //const article = <article>
  //  <p>Hello from the first paragraph</p>
  //</article>

  // `name="Batman"` is functioning as the prop declaration here
  ReactDOM.render(<App name="Batman"/>, root);
  // You can also do the following to allow for more dynamic naming
  ReactDOM.render(<App name={ name }/>, root);
}

// ./app.jsx
import React from 'react';

const App = (props) => {
  return <section>
    <h1>Hello, { props.name }</h1>
};
export default App;
```
Don't do any vanilla js DOM manipulation alongside react because those changes may not render
## Props
- don't set the props themselves to be dynamically changeable because react uses the props to determine when to render, so changing prop to be a different prop will take away reacts ability to determine if the content of the page should change
## State
- State is data that the component keeps track of for itself
  - Make sure not to accidentally define anything else to state, the state instance variable should only be used for state
## Class Components
- This is defining a component as a class
  - This is beneficial because it allows us to store instance variables
- Remember to `super` the props in the constructor in order to call the constructor of the parent class
- make sure to use `this.setState` because it triggers a re-render
ex:
```javascript
class DogIndex extends React.Component {
  constructor(props) {
    super(props);

	this.state = {vates: 0};
	// Make sure you bind all callbacks because react will call them function style
	this.vote = this.vote.bind(this);
  }

  vote() {
    // This needs to use `setState` in order to signal to react that it needs to re-render
	this.setState({ votes: this.state.votes++ });
  }

  render() {
    const breeds = [
	  'Corgi',
	  'Golden Retriever'
	];
    
	// Key is an important element in react because its how react finds elements that have the same attributes, this should always be used when using map and can be set to the index
	const breedLis = breeds.map(
	  (breed, i) => <li key={ i } onClick={ this.vote }>{ breed }</li>
	);

	return (
	  <section>
	    <ul>
		  { breedLis }
		</ul>
	  </section>
	);
  }
}
```
# Render
- **Re-render can be caused by using `setState`, prop changes, or parent state change**
  - All of these **will** cause a re-render, you shouldn't use them unless you actually want to render differently
  - This is very important for understanding life cycle methods and really any react module
- After the component has rendered at least once it is considered "mounted"
  - There are many things that you can't access until the component has mounted
  - Because of this you will occasionally need to set up some special logic to deal with some objects that will only become defined after render has been called the first time
	- For example: any ivars set in a `componentDidMount` method
	- You should avoid using map in the render because of this (at least for now) because it can cause some confusing errors
