# Important things/Hard to remember things
## **Method value** for special forms:
- You will need to add the following into any **method that is called from outside its named controller file**
```ruby
<form action="<%= session_url %>" method="post">
  <input type="hidden" name="_method" value="delete">
</form>
```
- `_method` tells rails to pay attention to this file and use the value given as the method to use to process the request because HTML doesn't natively handle delete requests
```
## **Authenticity_token** for forms:
```ruby
<input type="hidden" name="authenticity_token" value="<%=
form_authenticity_token" %>" >
```
The best place to put this is in `app/helpers/application_helper.rb` as:
```ruby
model ApplicationHelper
  def auth_token_input
    "input
	  type=\"hidden\"
	  name=\"authenticity_token\"
	  value=\"#{ form_authenticity_token }\">".html_safe
  end
end
```
This should then be called from the file with `<%= auth_token_input %>`

It will also be advantageous to add the file `_errers.html.erb` to `/app/views/layouts/` to display errors and notices, its contents should be as follows:
```ruby
<%= flash[:errors].join("<br>").html_safe if flash[:errors] %>
```
This should be called from `app/views/application.html.erb` with `<%= render 'layouts/errers' %>`
