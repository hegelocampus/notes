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
def self.find_bycredentials(email, password)
  user = User.find_by(email: email) # could be a user, could be nil
  return nil unless user && user.is_password?(password)
  user # return user if the email and password matches a user
end

def is_password?(password)
  bcrypt_password = BCrypt::Password.new(self.password_digest) # Digests password
  bcrypt_password.is_password?(password) # Checks to see if the input matches the hashed password
end
```
You will be expected to do basic user auth on the assessment
FeGrip (iron grip) to remember the user model  
The capital letters line up with the class methods
- `self.find_by_credentials`
- `self.generate_session_token`

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
    redirect_to bleast_url
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
  before_action :ensure_user_logged_id, only: [:create, :new, :edit, :update, :destroy] #Only users who are logged in can create a bleat
  # etc..
end
```
- Because we will probably be using this in a bunch of different controllers we should define this in the `ApplicationController`
```ruby
class ApplicationController < ActionController::Base
  def ensure_user_logged_id
    unless logged_id?
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
- be very cautious about dropping a space before the `#{ from_authenticity_token }` in the following
`value="#{ from_authenticity_token }" />`
If there is a space preceding the `#{}` then it will be taken into account when checking for a matching value
