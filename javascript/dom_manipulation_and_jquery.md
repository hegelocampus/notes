# The Document Object Model
- You can pick out objects in javascript by their HTML id using `document.getElementById("${ id }");`
  - This request asks the browser to return the element with the given `id`
  - You can create a new HTML object with `document.createElemnt`
  - This object won't actually get injected into the html until you use `appendChild`
e.g.,
```javascript
window.setTimeout( () => {
  const ul = document.getElementById("cats");
  const li = document.createElement("li");
  li.textContent = "This is injected by JavaScript";
  ul.appendChild(li);
}, 1000);
```
## jQuery
- Although the DOM is standardized it is not implemented identically across browsers
- jQuery is a library that builds on top of the DOM's functionality
  - jQuery essentially mends the irregularity issues between browsers
- jQuery is best thought of as a **wrapper library** that does low-lover DOM stuff for you
### Selection and Explicit and Implicit Iteration
- You can use `$` to select elements using CSS selectors
  -e.g., `$("li")` return a jQuery object that is fundamentally an array of html `li` elements
- jQuery objects are way better than node objects because they have a bunch of extra methods
  - Including:
    - an `#each` method that iterates through all of the elements
	- `#addClass` that adds the class to all elements in the object
	  - This is an implicit iteration
	- `#parent`, `#childern` and `#siblings` methods
	  - These are very useful because they make it so we don't have to deal with DOM as much
	- the `#val(value)` method allows you to set the value of an input tag
## Events
- jQuery has `jQuery#on(on(eventName, callback)` to listen for page changes
  - This works a lot like `EventTarget#addEventListener`
- You can also use jQuery to stop listening with `jquery#off(eventName, callback)`
## `$(document).ready`
- Script tags are immediately executed
- You can use `$` to have a script called after the DOM is fully loaded
- It is best practice to put all JS at the bottom of the page because a lot of JS can slow the loading of the page
## Event Delegation
- DOM events typically **bubble** so if an event fires on an element `X` that lives inside element `Y`, then after being fired on `X` the event will **bubble up** and be fired on `Y`
  - doing event delegation normally requires a hack-y solution that has faults, we can user jQuery to get around this
- This is what the three-argument version of `jQuery#on(event, selectior, callback)` is for
  - This method makes it so that the event handler is called whenever a particular event happens
  - 99% of the time this is used with `event.currentTarget`
## Form Submission
- You can create action listeners that take particular actions on form submission
  - The default browser action is to do a full page reload
  - You can override this and implement a cleaner looking action
e.g.,
```javascript
$(".todo-form").on"submit", function e => {
  e.preventDefault(); // This prevents the default action of the page reloading(duh)
  const $form = $(e.currentTarget);
  const $input = $form.find("#todo-text");
  const text = $input.val();

  $("<li>").text(text).appendTo($(".todo-list"); // creates an <li> element, adds the text to the element and then actually adds the element to the page
  $input
}
```

