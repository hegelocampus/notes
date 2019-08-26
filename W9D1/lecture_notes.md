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
  - `JSON` is comprised of a string that looks like javascript objects
  - You can `render json:` to display the JSON data
## Controller#show Action
- Information can be passed through a request in 3 ways
  - Through querry parameters
  - Through the URL path
  - Through the body
