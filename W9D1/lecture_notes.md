# Rails Routing
## Routing intro
### HTTP
- `GET` requests are made by typing something in as a URL
- HTTP status codes all denote something important about the state of the request
- Response body often returns a bunch of HTML that the browser then displays the web page
## Rails router
- Takes in the request and sends it to the proper controller
  - Rails is a **MVC** framework, that is **models, views,** and **controllers**
- There are many different ideologies on how to build a web application
  - The one we will be using is **REST**:
	- Getting information should be done through a `GET` request
	  - `GET` requests cannot have a body
	- Creating new information should be done through a `POST` request
	  - `POST` can actually do anything and some companies use if for everything but this is not RESTful
	- Updating should be done through a `PATCH/PUT` request
	  - `PUT` and `PATCH` are historically different but they are now pretty much the same
	- Deleting should be done through a `DELETE` request 
	- **RESTful** conventions hold that all actions should be done in terms of the preceding actions
### Anatomy of a URL
`https://www.google.com/something_here/longer_than_this/multiple_things?key1=val1&key2=val2`  
^scheme ^sub-domain     ^ This is all the path			  			  ^ query string begins with a ?  
			 ^This is the host
## Building routes
- `routes.rb` is in the config folder
- you first define the action in `routes.rb`
- Then you create a file in `app/controllers/${class_name}_controller.rb`
  - the controller name should be tabelized
- The controller action puts together a response to send back
- You start the file by defining the class for the controller
- You then define methods within that class
- **You can start up the rails server for testing by using bundle exec rails server**
  - You can see the actual HTML server on your web-browser at `localhost:3000`
  - Debuggers can be dropped in controller action methods
  - When your methods fail in rails your rails server will give you a weird debugger on your web browser
  - the better debug messages gem will give you much better debugging info
- It is convention to send data back as JSON
  - JSON is comprised of a string that looks like javascript objects
  - You can `render json:` to display the JSON data
- The controller will look at the **path** and the **method** 
## `Controller#show` Action
- This will be a `GET` request
- Information can be passed through a request in 3 ways
  - Through query parameters
  - Through the URL path
  - Through the body
## `Controller#Create` Action
- This will be a `POST` request to the controller
- Postman is a great client to use instead of the browser to test request types because it allows for much more complex requests
- All requests other than the `GET` request may hit an authenticator error
  - You can prevent this from triggering by using `skip_before_action :verify_authenticity_token` at the top of the controller class
- The create method would essentially be a factory method for the object you are attempting to create
- `#save` returns true of false depending on if it succeeded or failed, this is useful for creating conditionals based on if the data was successfully saved to the db
  - You shouldn't use a `#save!` though because it will return an error if it does not succeed and cause the web-page to fail
- You can nest params by doing something along the lines of:
  ```ruby
  bleat = Bleat.new(params[:bleat].permit(:author_id, :body)) # We'll do this a different way once we cover authentication
  ```
  - You will probably have to permit the values you want. You can do this by simply appending #permitted($(desired_value)) on the end of the method
  - The permit feature prevents users from sending unpermitted attributes to the db
- The above `POST` can be bolstered to protect against internal server errors with the following:
  ```ruby
  params.require(:bleat)
  ```
  - This will check that the user input contains the value we need and then raise a specific user input error if it does not find the value
## `Controller#update` and `Controller#destroy`
### `#update`
- This should be something like: 
```ruby
if bleat.update(bleat_params)
  render json: bleat
else
  render json: bleat.errors.full_messages, status:422
end
```
- You can clean this up with a private helper method to define the `bleat_params`
### `#destroy`
This can be as simple as this:
```ruby
def destroy
  bleat = Bleat.find(params[:id])
  bleat.destroy 
  render json: "Successfully destroyed the Bleat!"
```
- make sure you use the **destroy** method rather than the delete, because delete will only remove the object in question but destroy removes all related objects that you have defined using life-cycle hooks
- find will raise an error if it doesn't find anything so we don't have to deal with trying to `#destroy` a `nil` object

### Routes
- You can use the rails console to see all the routes that rails has made with `$ bundle exec rails routes`
- Nested routes also help to filter requests
