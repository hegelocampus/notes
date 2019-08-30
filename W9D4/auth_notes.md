## User Auth Notes
### User Model:
#### Validations:
```ruby
validates :username, presence: true, uniqueness: true
# Standard fair, username must be present and unique, could also be email, etc.
validates :password, length: { minimum: 6, allow_nil: true }
# If a password was set, we specify a minimum length.
# If it was not set (we're updating some other attribute, etc., where we didn't ask a user for their password again) we're allowing this to be nil.
# If we didn't allow nil we would have to send the plaintext password with every save/update, which would require the user to put it in on every editing form.
validates :password_digest, presence: true
# The user has to supply a password on account creation, but it doesn't have to be unique.
validates :session_token, presence: true, uniqueness: true
# We require our session token to be unique because it is how we find our current user.
# There's a very small chance the session token generated could already exist in our database.
# If it does and we allowed repeats, we could be giving a user access to another account since we are matching the current user to their session token.
after_initialize :ensure_session_token
# We generate a session token when a user creates an account.
# We never want a nil value for a session token since it could be matched by a nil cookie value.
```
#### Methods:
```ruby
FeGrip (Iron Grip)
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

### before_action
+ We can run a method before a controller action is called.
+ We typically use this on :ensure_user_logged_in for any action we need to have a current user for (creating/updating/displaying forms for these actions, etc)
```ruby
before_action :ensure_user_logged_in!, only: [:create, :new, :edit, :update, :destroy]
```

### Using current_user in controllers and views
+ We can display information or allow actions for the logged in user specifically by using current_user and associations.
+ For example, we only want a logged in user to be able to edit their own bleats. Instead of finding the bleat that matches the id directly, we can find them among the current user's authored bleats:
```ruby
@bleat = Bleat.find(params[:id]) # will return the bleat even if it was authored by another user
#vs
@bleat = current_user.authored_bleats.find(params[:id]) # will only return the bleat if the user is the author
```
+ Another example would be only showing edit and delete links on a show page for the author:
```erb
<% if @bleat.author == current_user %> <%# only renders the link and form if we authored this bleat %>
  <a href="<%= edit_bleat_url %>">Edit</a> |
  <form action="<%= bleat_url(@bleat.id) %>" method="POST">
    <input type="hidden" name="_method" value="DELETE" />
    <input type="submit" value="Destroy the bleat!">
  </form>
<% end %>
```

### SessionsController and Routes:
+ We use the singular `resource :session` to create our session routes, we are only ever going to have one session
+ Only need routes for `:new`, `:create`, and `:destroy` (login form, logging in, logging out)
+ Controllers are always pluralized, so we will still create a SessionsController
+ What does it mean to:
  + Log in: find the user by the supplied credentials (username/password, etc.), generate a new session token, set that user's token as well as the `session[:session_token]` cookie to the value
  + Log out: change the current user's session token and set the `session[:session_token]` to nil

### ApplicationController Auth Methods:
```ruby
lllec

helper_method :current_user, :logged_in? # allows us to use these methods in the views instead of just controllers

logged_in? # returns a boolean of whether a current user exists (using !!current_user)
log_in! # sets our @current_user to the user passed in and our session[:session_token] to our user's token
log_out! # resets our current user's token and sets our session[:session_token] to nil
ensure_logged_in! # redirects to the login page unless someone is already logged in (useful before_action in our controllers)
current_user # returns @current_user or sets it (finding a User by session_token) and returns it if currently nil
```

### Cross Site Request Forgery (CSRF)
+ Ensures that we are receiving the request from our own site
```erb
<%# new.html.erb %>

<form action="<%= action %>" method="POST">
  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>" /> <%# rails supplies the form_authenticity_token (through ActionController) %>
  ...
```
+ We have to include this hidden input for any form on our site in order to provide the authenticity_token parameter
+ We can also include this in the `application_helper.rb` as a method that we can call instead of typing out the input for each form:
```ruby
# application_helper.rb

module ApplicationHelper
  def auth_token
    <<-HTML.html_safe
      <input type="hidden"
        name="authenticity_token"
        value="#{form_authenticity_token}" />
    HTML
  end
end
```
```erb
<%# new.html.erb %>

<form action="<%= action %>" method="POST">
  <%= auth_token %> <%# we can just call our auth_token method in all of our forms now %>
  ...
```

### session, flash, and flash.now
+ Can be thought of as variations on the life of a cookie
  + `flash.now[:whatever]` will only be available for the current request
  + `flash[:whatever]` will be available for the current request and the next one
  + `session[:whatever]` will be available until it is destroyed
+ We can use `flash` and `flash.now` to show error or success messages
  + Use `flash` for a redirect since we are making a new request
  + Use `flash.now` for a render since we are in the same request
+ We can use `session` to create a long-lasting cookie, such as storing a session token to indicate a user is logged in
