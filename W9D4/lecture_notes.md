# Lecture notes
## Flash
- Flash is a cookie that is only avaliable for the next request
- The flash cookie is stored within the session cookie
- This type of cookie is useful for showing a successfully saved message on the page that you get sent after submitting a form
- If you are rendering right away (as in you aren't redirecting) you can use `flash.now[{hash}]`
  - `flash.now` is only avaliable for the current request
- Error keys, success keys, and notice keys are the three types of messages that are normally used with flashes
## User Password Functionality & Signup
- When rails puts together the SQL query to insert the password into the db, the BCrypt::Password is translated into a string
- We need to make sure that we write a `#password=(new_pass)` method to translate the input into a hash so that we can either store it in an encrypted form
```ruby
def self.find_by_credentials(email, password)
  user = User.find_by(email: email) # could be a user, could be nil
  return nil unless user && user.is_password?(password)
  user # return user if the email and password matches a user
end

def is_password?(password)
  bcrypt_password = BCrypt::Password.new(self.password_digest) # Digests password
  bcrypt_password.is_password?(password) # Checks to see if the input matches the hashed password
end
```
***You will be expected to do basic user auth on the assessment***  
Use FeGrip (iron grip) to remember the user model  
The capital letters line up with the class methods
```ruby
F: self.find_by_credentials
   # Returns the user model that matches the username/password combo (or email, etc.)
e: ensure_session_token
   # If a session token has not been created, generates a new one and sets the model's attribute
   # This is useful for creating a session token for a new user since they will not have one stored in the database yet
G: self.generate_session_token
   # Returns a urlsafe_base64 string from the SecureRandom class
r: reset_session_token!
   # Generates a new session token, persists the new token to the database, and returns the new token
   # (We return so that we can easily put the new token in our cookies)
i: is_password?
   # Compares a plaintext password to the password_digest stored in our database (through BCrypt)
p: password=
   # Sets our model password attribute as well as creating the password_digest (through BCrypt)
```
## Auth Intro, Log In on Signup, & `#current_user`
- It is good practice to put `#current_user` in the `ApplicationController` with `helper_method :current_user`
  - This exposes the method to the controllers and the views
The `#logged_in?` method would look something like this, it should also go in the `ApplicationController`
```ruby
def logged_in?
  !!current_user
  ##!!nil => false # This is just exposition
  ##!!user # This too
end
```
The double bang here is coercing a possibly nil value into a boolean  
  
- We should use the `session_token` to determine who a user is rather than a `:user_id`
  - This is because it would be pretty easy to go through all the user `user_ids` by just going one by one through them
  - `session_tokens` solve this problem because they are randomized
## `SessionsController`
- The most important part here will be the `#create` method, it will look something like this:
```ruby
def create
  user = User.find_by_credentials(
    params[:emails],
    params[:password]
  )

  if user
    session[:session_token] = user.reset_session_token
    flash[:success] = "Logged in succesfully. Welcome back!"
    redirect_to bleats_url
  else
    flash[:error] = "Wrong email/password combo"
    render :new, status: 401 ## This is the unauthorized status
  end
```
- The destroy is also important
```ruby
def destroy
  current_user.reset_session_token! # Reset the users token back to nil
  session[:session_token] = nil # Set the session_token back to nil
  flash[:success] = "Logged out successfully"
  redirect_to bleats_url
end
```
- To be safe we should **create a new session token when the user logs back in**, rather than recycling the old one
- Its common on the assessment to forget that a user only ever has a single session
  - Despite this the controller should be pluralized
## Authorization (`before_action`)
- Within the controller methods you need to make sure you have a current_user so that if there isn't a current user, the action methods won't attempt to call a method on a `nil` user
- This requires a `before_action`
```ruby
class BleatsController < ApplicationController
  before_action :ensure_user_logged_in, only: [:create, :new, :edit, :update, :destroy] #Only users who are logged in can create a bleat
  # etc..
end
```
- Because we will probably be using this in a bunch of different controllers we should define this in the `ApplicationController`
```ruby
class ApplicationController < ActionController::Base
  def ensure_user_logged_in
    unless logged_in?
      flash[:error] = "Must be logged in to perform that action"
	  redirect_to new_session_url
	end
  end
end
```
- To restrict bleat editing to the author of the bleat you can do something like this
```ruby
def edit
  @bleat = Current_user.authored_bleats.find(params[:id])
  render :edit
end
```
To hide the destroy button for non-author users you can do the following:
```html
<% if @bleat.author == current_user %>
  <a href="<% edit_bleat_url %>">Edit</a>
  <form action="<%= bleat_url(@bleat.id) %>" method="POST">
    <input type="hidden" name="_method" value="DELETE" />
    <input type="submit" value="Destroy the bleat!" />
  </form>
<% end %>
```
## CSRF Attacks & Protection
- This attack is where a different site displays a form that mimics our form that tries to send the request to our site to act as the user
  - This form can look like anything, it could just be a button that says "click here to win a million dollars"
  - The cookies that are on the browser will be sent with the request, so this request will look like its coming from a signed in user
- To protect against CSRF attacks you can do the following:
  - Add `authenticity_token` check to the `_form.html.erb`
  `<input type="hidden" name= "authenticity_token" value="<% form_authenticity_token %>"/>`
- To get around this on our own app we will have to add the `authenticity_token` on any request that isn't a `GET` request
- Be very cautious about dropping a space before the `#{ from_authenticity_token }` in the following
`value="#{ from_authenticity_token }" />`
  - If there is a space preceding the `#{}` then it will be taken into account as part of the string when checking for a matching value
  - This is pretty obvious but it is very easy to do by accident and it is a bug that is very hard to catch
- Rails automatically escapes all content within ruby methods as being not html safe, you can indicate that something is html save with `<<-HTML.html_safe`
  - You can use such a syntax to create a method that you can call from a `*.html.erb` file
## Auth Review
- User sets a password
  - That password is hashed and the hashed password is assigned to the user in the db
- A session_token is generated and is also assigned to the user
  - We can either just create a brand new session token, or use `reset_session_token` it doesn't really matter which one we use here
  - **A session token being assigned to the user is effectively what signs the user in**
    - If there isn't a session token then the user is not signed in
- We then call `#save` on the user to commit the data to the db
- The user can then proceed to make user-restricted requests
- If the user were to try to bleat:
  - We would check to see if the user is `logged_in?`, and reroute them back to the login screen if they are not
  - We would then make sure we only allow the user to edit and destroy the objects that _they_ created
- After the user does an action we would reset the `session_token` as an added layer of security
  - We would also set a flash to display the status of the action (i.e., success, or failure)
- If the user were to log out and log back in we would call `#reset_session_token` to reattach their session token with the one we have saved on our db
  - Part of them logging back in will be checking their password username association
	- Its best practice to not give any indication that a username is correct if they give you an incorrect password  
The `ApplicationController#current_user` method should be set up to only call the query to find the user the first time the method is called, this can be done easily with a lazy initialize:
```ruby
def current_user
  return nil unless session[:session_token]
  @current_user ||= User.find_by(session_token: session[:session_token])
end
