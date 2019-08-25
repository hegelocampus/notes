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
- You can use `rails routes` to get a complete list of all avaliable routes
  - This lists routes in the order they appear in routes.rb
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

