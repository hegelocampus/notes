# A04 Notes
## Models
- You will have the best time if you run one set of specs at a time
- Remember to add an index on username for faster lookup
- Make sure to never add password to the database
- For password make sure to set a min length of 6 and allow_nil values
```ruby
validates password, length: {minimum: 6, allow_nil: true}

attr_reader :password

after_intialize :ensure_session_token

def self.find_by_credentials(username, password)
  user = User.find_by(username: username)
  user && user.is_password?(password) ? user : nil
end

def is_password(password)
  BCrypt::Password.new(self.pasword_digest).is_password?(password)
end

def password=(password)
  @password = password
  self.password_digest = BCrypt::Password.create(password)
end

def reset_session_token!
  self.session_token = SecureRandom.urlsafe_base64
  self.save!
  self.session_token
end

def ensure_session_token
  @session_token ||= reset_session_token!
end
```
## Routes and Controllers
- Adding some methods in the `app/models/application_controller.rb` will help
    you out a lot
```ruby
def login(user)
  session[:session_token] = user.reset_session_token!
end

def current_user
  @current_user ||= User.find_by_session_token(session[:session_token])
end

def require_login
  redirect_to new_session_url unless logged_in?
end

def logged_id?
  !!current_user
end

def logout
  user.reset_session_token!
  session[:session_token] = nil
end
```

## Controllers
- You will likely need to generate this
`rails g controller Users`
`rails g Sessions`

### User Controller:
```ruby
class UsersControler < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # Check the specs to see where we need to send the user after login
      login(@user)
      # redirect_to links_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
  end
end
```
### Sessions Controller:
```ruby
```
