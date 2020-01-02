## Technical trivia
### HTML trivia
#### Hightlight text using only HTML
- use `<mark>` tag
#### Reverse text direction
- use `dir="rtl"` in the text element's tag
#### What is a semantic HTML tag
- A tag that tries to describe what sort of formatting it performs, these tags are preferred over other non-semantic tags
#### What is an optional closing tag
- some tags are self closing such as the `<br>` and `<a>` tags so they don't need a closing tag
#### Why do you need `doctype` at the beginning of your HTML document
- This ensures that your document renders in the `standand` type mode
#### When you zoom in on your browser and the page gets bigger what exactly happens
- The width of pixels is actually stretched, the page's elements still retain the same pixel sizes, the rendering of the pixels is the only thing changed
#### What does the `<details>` tag do
- It creates a hide-able drop down that displays details about the webpage
### DOM manipulation
#### Is there a difference between `window` and `document`?
- The window is the first thing that is loaded into the browser, the document is part of the window object the document is the `html` and has its own properties
#### Do `document.onload` and `window.onload` fire at the same time
- `document.onload` is called when the document is ready, which may be before the content has loaded
#### What are the different ways to get an element from the DOM
- getElementById
- getElemntByClassName
- getElemntsByTagName
- querySelector
- querySelectorAll
#### What are the different ways to select elements by using css selectors
- id
- class
- tag
- sibling
- child
- decedent
- *
- attribute
- pseudo selectors
#### Can I use `forEach` or similar array methods on an `HTMLCollection`? What about a `NodeList`
- In the DOM everything is a Node, we cannot over an `HTMLCollection`, but we can over a `NodeList`
- `querySelectorAll` returns a `NodeList`, `getElementByTagName` returns an `HTMLCollection`
#### How do you implement `getElementsByAttribute`
- You can use `Document.all` and then use a for loop to selectively look through each element and put it into an array holding all of the elements with the desired attribute
#### How would you verify whether one one element is the child of another
- You can use `document.createElement`, it takes in a string and builds an element

