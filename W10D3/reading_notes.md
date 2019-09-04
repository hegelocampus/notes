# CSS
## CSS pseudo-content
- Pseudo-content is stuff that isn't truly content but is stuff that adds information to the webpage that isn't strictly content, e.g., icons.
- This content is injected inside a tag before the actual content of that tag
This is how you write pseudo-content
```css
  h1 {
    background: pink;
  }
  h1:before {
    content: "☭"
  }
```
- You can give the pseudo-content all the special types of modifiers that you can give normal html elements
- A real world use of this is to show the link location of a link
  - You can access the link location of a `href` using `attr(href)`
```css
a:after {
  content: "->" attr(href);
}
```
