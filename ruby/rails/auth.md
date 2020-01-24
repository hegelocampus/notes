# Rails Auth
## Authentication
### Strategies?
- There is no good way to do authentication trough URLS because `HTTP` is stateless 
- The only real solution is to use cookies
### Cookies
- The clients browser is actually what sets the rules for the cookies
- Cookies are sent up in the headers of the clients requests
- Although this doesn't solve the authentication problem by itself
  - This is because any client can change any of their cookies on their own
  - This basically means they can wreck total chaos
### Authentication
- The solution to the above is to send over a `session_token` that holds the users id, that we expect to be sent back whenever the user comes back, when the user logs out the `session_token` on the server end would get deleted
  - This `session_token` is only sent over after the server is given a correct username/password combo
### Encoding, encrypting
- **Encoding** is storing info that essentially just needs a pattern to translate it back and fourth from plain to encoded text
  - Base64 encoding is a very popular encoding method that uses a standardized ASCII table to encode text
	- This encoding method is used for pretty much everything
  - Encoding is weak because it is very easy to decode it if you know the system that translates the string into the encoded text
- **Encrypting**
  - Encrypted data requires a much more complicated translation method that allows for the data to be translated in a multitude of different ways
	- E.g., the Ceaser cipher can translate the string into an indeterminate number of possible results by simply changing the parameters that control how many characters are shifted
- If the server stores all the users passwords as plain text then those users are incredibly vulnerable because servers breaches aren't completely preventable
- We should defend user info (especially passwords) against the strongest possible attacker, such an attacker would have access to all server data
  - The solution isn't encrypting or encoding
- Even encryption is at risk of data breaches because your server must hold the decryption method in order to test if the user is valid, this means that it may be slightly harder to gain access to user passwords, but if someone has already breached into your database they probably have the means to steal your decryption method
### Hashing
- Hashing is the solution to the authentication problem
  - Hashing is a one way method, there is no way to get from the output of the hash function back to the original input
  - Hashing can be used to store passwords because hashing is uniform so the same input will always result in the same result
  - We can store the users `password_hash` without having to risk releasing the users password to the outside world
- One issue with hashing is **hash collisions**
  - Hash collisions are when **two unique inputs result in the exact same hash**
  - Hash collisions are unavoidable because math, we can make them exceedingly rare but it will always still be a possibility
- **Cryptographic hashing functions** are a special group of hashing functions that are extremely secure and have extremely low collision rate
  - Some examples:
	- SHA-1
	- MD5
	- SHA-2
	- Scrypt
	- Bcrypt (Blowfish)
  - Cryptographic hashes typically produce massive hashes
  - You should always use the most up to date hashing function because all hashing function eventually are cracked and become very weak
### Salting
- The biggest weakness of hashes is that ***USERS ARE STUPID*** 
  - Users reuse passwords so a users password is only as strong on the weakest sight they gave their password to
- **Rainbow tables** are collections off a huge percentage of the most common passwords that been run through all the most common cryptographic hashing functions
  - Because the majority of users use a most popular passwords all you need to breach the data of most of your users is a rainbow table
- The solution to dumb users is **Salting**
  - Salt is a random bit of information that gets added to the users password before it is hashed this will cause the hash to be different than what is on the rainbow table
  - The server needs to then store the hash along side the users info so that we can always add the same salt to the users inputted password to check it against the hashed value
- Salt makes it incredibly hard for an attacker to get the users data, and **with randomly generated salt, all users will have unique data in the table so there will not be a large chunk of the passwords with the same hashed value (indicating a weak common password)**
  - Although this may be the case you can still break into the users data using a brute force attack trying every possible combination on the end of the password and then hashing that value
  - This may sound like a huge task but there are massive networks of bot-nets that constantly mine for passwords
  - The best defense of the above attack is to make it so that is is an economically unfeasible endeavor to crack a users password, you should make the cost of breaking a users password to exceed the return of selling the information associated with the user
	- You can do this easily by simply re-running the users hash back through the hashing function
	- This takes a lot of time for us, and thus also costs us money, to do so we shouldn't put the users password through the hashing function a ridiculous number of times
### BCrypt example
- You can play with Bcrypt using `BCrypt::Password.create("#{password}")` in pry
- BCrypt stores the salt and the hash in the same string
- You can check if a value is the password to a `BCrypt::Password` object using `#is_password?(${string})`, this will use the salt and the hash to check the value
  - This is a very expensive method
### Session, flash
- **Session** is a hash that is avaliable to you similar to params
  - You can access the values in this just like the params
  - The session is a tamper-proof version of cookies
  - cookies are not permanent and last a very maximum of 20 years
- You can set a cookie to expire much earlier. Using Rails you can create a **flash** cookie that only lasts for a single request
  - You can even use flash to send a cookie that only lasts for the current request
	- This is actually technically not a cookie because it isn't persistent
### Auth Pattern
- You should never use your own authentication, its a bad idea, very very smart people have spent years doing nothing but figuring out how to do authentication well, you should just use theirs
- With that said, here is how authentication works:
  - When you go to save the users password you word do something like create a beaker password based on the users input after they send over their password, so we would save their hashed password rather than the plain text password. This allows us to store a version of the users password without storing their actual password
  - You also will take their session using `generate_session_token` `ensure_session_token!` and `reset_session_token!`
  - You use the session token to determine who the user is
  - You will need some kind of redirect if the user is not logged in
### CSRF attacks
- These are attacks that are from a foreign sight that is forging a request as the user in order to gain access to their account
- These attacks only work if the user is signed in
### CSRF protection
- To build protection against a CSRF attack you can use a randomly generated token that will be stored in the HTML form and the session using `self.session[:_my_csrf_token] ||= SecureRandom::urlsafe_base64`
- The form will then check that the token from the session matches the token that we generated
  - This validation will do nothing if the token given with the request is the same as the same as the token saved from the session, else it will raise an error
  - This type of check should only happen for post request
	- This is because we only care about requests that can do a malicious action
- But you don't have to do any of this yourself because rails has it built in
  - Rails has it named as `protect_from_forgery with: :exception`
	- This will install a before filter that checks the request type
	- The old default here is no log the user out of the session rather than raising an exception, this is bad and confusing but is still sometimes the way CSRF protection is being implemented on older rails projects
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
  bcrypt_password = BCrypt::Password.new(self.password_digest) # Turns password_digest back into BCrypt object
  bcrypt_password.is_password?(password) # Checks to see if the input matches the hashed password using BCrypt::Password#is_password?
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
    params[:email],
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
