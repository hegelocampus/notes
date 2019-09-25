# Week 12 Day 2: jQuery


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
