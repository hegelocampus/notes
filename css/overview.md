# Rails and CSS
## Overview of CSS
- CSS stands for Cascading Style Sheets. It is a style sheet language for markup
  - CSS is 'Cascading' because multiple files can be combined to style a page.
- CSS style can be added to HTML in three different ways:
  - Inline
  - Internal CSS
  - External CSS
- External is the preferred implementation
#### Inline Style Attribute
- These are added directly to an HTML element inside the elements opening tag
- This implementation ensures that the element will be styled with the given style
- This is very messy and very not DRY
- Using this method it is also impossible to style pseudo-elements and classes
#### Internal: Embedded style tag
- This is essentially CSS that is added to an html document within its own HTML tag within the `<head>` of the document
- This is cleaner than inline styles
- It also allows for style to be applied to multiple different elements on a page
- It is more dry than inline
- The biggest drawback is that this implementation is loaded with the HTML page and is **not cached by the browser**
#### External file: linked stylesheet
- This implementation allows for the style to be cached by the browser for improved performance
- It also allows for use of the same style sheets across all pages in your site
- Because of the later it also means that developer must be careful to structure the CSS so it doesn't style unintended elements
## CSS Pre-Processors
- These are essentially languages that are compiled into CSS and then ran as CSS
- They extend the functionality of CSS with variables, nesting, functions, mixins, operators, and more
- They decrease stylesheet maintenance costs and help to write even DRY-er code
#### SCSS and Sass
- SCSS is a superset of CSS3  so every valid CSS3 stylesheet is also valid SCSS.
- Sass is an older version of SCSS that uses line indentation rather than brackets and semi-colons to specify blocks
- Supports while and each loops
#### Less
- Less is inspired by and very similar to Sass
- It has less features and relies on mixins for custom functionality
- Does not support while or each loops
#### Stylus
- Also uses line indentation and white space instead of semi-colons and brackets
- It is the most like a complete programming language of the popular pre-processors
- Special features include:
  - splats
  - conversion of files to base64
  - hashes
  - color blending
- A lot less beginner-friendly and much less community support
### CSS frameworks
- A CSS framework is a package of pre-structured and standardized code that supports CSS development
## CSS Responsive Design
- A design is responsive if it looks good on many different devices with different sized screens
### Media Queries
- A media query is a wrapper for CSS code that tests the display conditions of a device
- There are two parts of this condition:
  - That the _media type_ is a `screen`
  - The second is `min-width`, this specifies that these styles only apply on devices where the screen is greater than or equal to the given width.
	- These are useful if you want different designs for phones and desktop computers
- We can list multiple conditions and combine them with AND/OR logic
### Responsive design process
- The best way to build responsive design is to determine the appropriate breakpoints for your site.
  - A **breakpoint** is a width measurement that represents the point at which your website would need substantial changes to accommodate the screens w/in that range
- To discover your websites breakpoints you should start viewing your site in a full desktop window and then slowly resize. Every time the layout starts to look bad you should note which elements need to be tweaked. If you have devtools open chrome will tell you the size of the open window
### Mobile-First Design
- Designing specifically for phone users first because so many people use the web on their phones
- The main ideology behind this principle is to design for phones before desktop sites
  - Support for larger devices is then added through min-width media queries
  - This strategy leads to adding more elements for larger screens rather than subtracting them for smaller ones which means that all the important elements will always be visible of both screen types
### Viewport Meta tag
- You will need to add this tag to enable a responsive layout:
```html
<meta name="viewport" content="width=device-width, initial-scale=1" />
```
- This is added to the head
- This tag tells the mobile browser that the site is designed to support small screen sizes and that it should display the site with an initial zoom of 100%
