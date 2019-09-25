# Reading Notes for W12D4
## Javascript DOM api
### jQuery Part 7: triggering
- You can trigger events manually too using `jQuery#trigger(foo)`
### Event propagation
- **The Bubbling Principle**: After an event triggers on the deepest possible element, it triggers on its parents in nesting order.
  - i.e., the most inner element will trigger first and then trickle out
- You can stop event propagation using `event.stopPropagation()`
  - This will prevent the event from bubbling any further
### History and Location
- You can manipulate the user's history using `window.histroy`
- You can do the same with the current url using `window.location`
### Vanilla JS DOM manipulation
- Important methods:
  - `document.getElementById`
  - `Element.getElementsByClassName`
  - `Element.querySelectorAll`
  - `EventTarget.addEventListener`
  - `Node.appendChild`
  - `Node.removeChild`
