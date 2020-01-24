# Rails lite
- Its really important to learn how rails actually works so that you can smoothly transition to a different stack
##What does rails actually do
- When a webserver gets a request it sends back a response that has a content length of variable length
  - The response declares the content length so that the web browser knows when the response has been fully received
- Part of the rails functionality is hot-reloading so we won't have this functionality
### Most basic rails
```ruby
require ` rack`

most_basic_app = Proc.new do
  [
    '200', # This is the response code
	{'Content-Type' => 'text/html'}, # This is the content-type
	['This is the most basic rack app.'] # This is the response
  ]
end

most_basic_redirect_app = Proc.new do
  [
    '302', # Redirect code
	{'Content-Type' => 'text/html', 'Location' => 'https://www.google.com'}
  ]
end

# most_basic_app.call
Rack::Server.start({ app: most_basic_app, Port: 3000 })

```
### Less basic app
```ruby
less_basic_app = Proc.new do
  res = Rack::Response.new
  res.status = 200
  res.set_header('Content-Type', 'text/html')
  res.write('not so basic rack app')
  res.finish
end
```
Rack response just holds all of the data in a convenient package that can be given dynamic values
- The way this is set up all all responses just go to the exact same place
### Even less basic app (cookie party)
```ruby
cookie_party_app = Proc.new do |env|
  req = Rack::Request.new(env) # This will be a big ol' pile of readers
  res = Rack::Response.new
  res.write("<h1>COOKIE PARTY</h1>")
  if req.cookies["cookie_party"]
    res.write("<h2>We have cookies for our party!</h2>"
  else
    res.write("<h2>Aw, there's no cookies! Refresh to make some.</h2>"
  end
  res.set_cookie("cookie_party", { value: true })
  res.finish
end
```
- The `env` sends in the data contained in the environment that the request is made under
- This allows us to do different things based on different environmental inputs, including path info, server setup info, and cookies

