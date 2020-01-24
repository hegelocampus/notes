- You can make rails automatically load the `serializeJSON` plugin by including the `serialize_json-rails` gem
## AJAX
- AJAX allows for server requests to be made in the background so that the browser doesn't have to wait for a db request to be processed to display more info
  - Think infinite scrolling, music streaming, and gmail
  - Ajax allows for cool websites that don't require page reloads
- The responses still use the rails routers to get the information
- Ajax can use the jQuery framework
  - But you can do this with anything, even with just rails
client side:
```javascript
$.ajax({
  method: 'POST',
  Url: '/cats',
  dataType: 'json',
  data: cat,
  success: function... //this is ran when ajax responds to the request
})
```
server side:
```ruby
render json: cat
```
## jQuery AJAX methods
- `$.ajax` (low-level, complete interface)
- `$.get` ("more convenient" function for GET requests)
- `$.post` ("more convenient" function for POST requests)
## Using Rails as an API
- When a controller only serves database info (`json` for example) it is called a **web API**
- To make rails an API we have to write our views to serve up raw JSON instead of HTML
  - This sort of view is called an **endpoint**
- Rails is smart and if a request with a header for `Accept: application/json` comes in the controller will automatically try to render the `app/views/foo/index.json.jbuilder` file instead of the `app/views/foo/index.html.erb`
  - All you need to do is actually write that view, e.g., `json.array! @cats`
### How to use Rails as an API (from JS)
- You will need to **try** to request the JSON from the server
```javascript
$.get({
  url: '/foo',
  dataType: 'json' // this is where the request type is specified
})
```
- Controllers are versatile and can be setup to handle multiple different format types of request
```javascript
class CatsController < ApplicationController
  def index
    @cats = Cat.all
    
    respond_to do |format|
      format.html { render :index }
      format.json { render :index }
    end
  end
end
```
## Promises
- An ES6 feature that simplifies callback to asynchronous functions
- Promises allow you to write hypothetical callbacks that _will_ be called but not quite yet
- Promises can exist in one of three states:
  - pending: The promises is neither fulfilled nor rejected
  - fulfilled: The promise's action has succeeded
  - rejected: The promise's action has failed
A promise is **settled** when it has been fulfilled or rejected
- They can only succeed or fail once
## Creating a Promise
```javascript
const p = new Promise(executor);
```
This accepts a single `executor` argument
- This is a special argument that takes `resolve` and `reject` as optional args
/
