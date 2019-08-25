# Routes and Controllers
## Routing I: Basics
What does routing even mean?
What does it mean to use root?
What is RESTful?
What is CRUD?

## Rails Router
- The Rails router recognizes URLs and chooses a method to dispatch the request
- Router defines the structure of the application's API
  - The router defines the valid paths w/in the code
### Resource Routing: the Rails Default
- Resource routing generates a mapping from a set of standard url paths to set conventional controller actions.
- Places in the path that start with a colon are called dynamic segments
  - They can match any string not containing a forward slash
  - The dynamic segment is typically the primary key of the model
#### **Follow the conventions**
- Controllers are **always** named in the plural. When defining a plural resource **always** use the plural name
  - In the future we will cover singular resources, but we don't need to worry about that yet
### What does RESTful mean?
- The REST philosophy is that actions, more complicated than creating/reading/updating/destroying a **resource**,should be thought of in terms of **CRUD**(create/read/update/destroy) actions on resources
  - This means that instead of creating a special action on a resource we should just use a CRUD method
  - E.g., if you want to be able to like a photo, rather than creating a unique 'like' method, we should create a like object that can be attached to the original object and created and destroyed as needed.
## Paths and Routing Helpers
- Specifying a resource route will create a number of **routing helper
    methods** that your controllers can use to build URLs.
  - If you build URLs by hand in Rails you're doing it wrong
  - The routing helpers are less error prone and tedious than doing it by hand
- Some people use a `_path` version of there helpers, but it just gives you a
    path and not a full URL so you should just use `_url`
## Inspecting and Testing Routes
- You can use `rails routes` to get a complete list of all available routes
  - This lists routes in the order they appear in `routes.rb`
  - You can tack `_url` after this to get the routing helper
  - This will display:
    - The route name
    - The HTTP verb
    - The URL pattern
    - The controller#action to route to
## Using `root`
- You can specify the controller action that Rails runs for `GET /` by using
    the `root` method:
```ruby
root to: 'posts#index'
```
- This invokes the `PostsController`'s `index` method when the root URL is requested

## Controller
### Initial thoughts
- What is the controller?
- What needs to be controller?
- Why do controllers have parameters?
### What Does a Controller Do?
- After routing has determined which controller to use for a request, the controller is responsible for handling the request and producing the desired output
- It is the controller's job to:
  - Ask the model layer to fetch data
  - To process user input
  - To either build and send a response or redirect the user to a new path
### Methods and Actions
- Rails will automatically generate a blank class named `ApplicationController` which extends the `ActionController::Base`
  - Your controller code will go in the subclasses of `ApplicationController`
- When your application receives a request the router will determine which controller and **action** to run.
  - The router will instantiate an instance of the controller and call the method that is named by the action
- **Controller naming convention is to _pluralize the name of the model_ **, and tack on "Controller"**
### Strong Parameters 
- The two main parameters that are possible in a web application are:
  - Query string parameters: The parameters that are sent as part of the URL
	- These are available in a hash-like object returned by the `ActionController::Base#params` method
  - The parameters contained w/in the request body
	- Any kind of request could contain a body, but typically only `POST` and `PUT`/`PATCH` do
    - This information usually comes from an HTML form which has been filled out by the user
	- Rails mixes the query string parameter and request body together in the `#params` method
	- User submitted info is usually stored in a nested hash
- The `id` parameter is the third parameter that is often used in queries, it is set from `params[:id]`
  - This is sometimes called a **route fragment parameter**

