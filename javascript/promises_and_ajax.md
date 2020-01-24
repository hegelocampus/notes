## Promises
- Promises simplify making asynchronous callbacks
- Remember to return the `$.ajax` in order to make sure the promise is doing something
## AJAX
- Your webpack config file is a good thing to setup so you don't have to pass the cli a bunch of options every time you run webpack
  - `devtool: "source-map"` points your debugger at the actual original files rather than the huge combined files
- `application.js` is where all JS plugins will go
- **Don't delete any of the comments in the `application.js` file**
  - Rails reads from the comments in order to require files, any break in the comments will cause rails to stop looking for files to require
- In the future don't try to open `bundle.js` because it will be a huge file that includes all the files required by whatever plugin you're using (e.g., the entire react base library)
- You can construct a new html element in JS in the following way
```javascript
$bleatsUl.append(
  bleats.map(bleat => {
    return $("<li>").html( //this html tells js that the following is html and shouldn't be html-escaped
	  $("<a>")
	    .attr("href", `/bleats/${ bleat.id }`)
		.text(bleat.body)
	)
  })
)
```
- You need to make sure you wait for the objects that event listeners are watching to actually load before you ask them to wait for an action
- If you put bleats controller in an api folder you have to setup the naming as such
  - This is the typical setup for a web app
  - `class Api::BleatsController`
## Forms with AJAX
- The first thing should **always** be `e.preventDefault();`
  - This will prevent tho form from just doing the default action of submitting and redirecting
```javascript
const $bleatForm = $("#bleat-form");
const $bleatBody = $bleatForm.find("#bleat-body");
$bleatForm.on("submit", function(e) { //this binds on the submit event of the form
  e.preventDefault(); // Always always prevent the default
  const bodyText = $bleatBody.val();

  $.ajax({
    method: "POST",
	url: "/api/bleats",
	data: {bleat: {body: bodyText, }},
	success: function (bleat) {
	  // debugger; // putting a debugger in the success/error function is a good way to see if its working
	  $bleatsUl.append(
	    $("<li>").html(
		  $("<a>")
		    .attr("href", `/bleats/${ bleat.id }`)
			.text(bleat.body)
		)
	  )
	},
	error: function() {
	  console.log("error");
	}
  });
}
```
- This is a really messy way of doing this: here's how to refactor it
## APIUtil & Promises
- You can replace the function calls in the `$.ajax` with a promise
- You can put special 'helper' functions in a `frontend/util/apiUtil.js` file
  - This helps to clean up code and make it a lot more readable
  - This way you can delegate actually rendering all to the `frontend/entry.js` and the api fetcher files to another file
A typical pattern is to save a fat arrow function to a constant while also declaring it as an export, e.g.,
```javascript
export const createBleat = (body) => {
  return $.ajax({
    method: "POST",
	url: "/api/bleats",
	data: { bleat: {body: body, author_id: 1})
}

//./util/entry.js
//import * as apiUtil from './util/apiUtil.js'
import createBleat from '.util/apiUtil.js'
```
