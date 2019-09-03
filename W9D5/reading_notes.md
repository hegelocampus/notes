# Rails Auth II
## Radio buttons in rails
- All the radio buttons for a group get the same name
- Different values though
- You can wrap them in a label to give them a label
## Helper methods
```ruby
<%= button_to "Destroy Cat!", cat_url(cat), method: :delete %>
```
  - The `cat_url()` is a helper method that was created here to return the url of a cat
- These are a handy way to clean up code, they aren't super magic and you have to write them yourself in the helpers folder
## Layouts
- The layouts folder will hold all the functionality that is contained across all the different pages
- You can overwrite the layout by specifying content for the same tag a specific html file
## `ActionMailer`
- You can generate a mailer using `rails generate mailer ${mailer name}`
- `app/mailers/user_mailer.rb` will contain the empty mailer
Here's an example mailer:
```ruby
class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end

  def reminder_email(user)
    # ...
  end

end
```
- To send multiple emails you can use an array of email strings
- You can put the name of the recipient in the email like this: `Ned Ruggeri <ned@appacademy.in>"`
- Keep in mind that mailing is slow, we'll learn how to batch send emails in the future
