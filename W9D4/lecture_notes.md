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
- self.find_by_credentials
- self.generate_session_token

## Auth Intro, Log In on Signup, & `#current_user`
- It is good practice to put `#current_user` in the `ApplicationController` with `helper_method :current_user`
  - This exposes the method to the controllers and the views
The `#logged_in?` method would look something like this, it should also go in the `ApplicationController`
```ruby
def logged_in?
  !!current_user
  #!!nil => false
  #!!user
end
```
The double bang here is coercing a possibly nil value into a boolean  
  
- We should use the `session_token` to determine who a user is rather than a `:user_id`
  - This is because it would be pretty easy to go through all the user `user_ids` by just going one by one through them
  - `session_tokens` solve this problem because they are randomized

