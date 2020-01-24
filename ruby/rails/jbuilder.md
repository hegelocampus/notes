# jBuilder
- This allows us to construct our JSON so that we know we are only ever sending the user the information that they actually need
It will look something like this
```ruby
json.array! @bleats do |bleat|
  json.extract! bleat :id, :body, :author_id
end
```

- You can even use a partial in your json render
```ruby
json.array! @foos do |foo|
  json.partial! "/api/foos/foo", foo: foo
  # You can get information about the associations like so
  json.author do
    json.extract! bleat.author, :id, :email
  end
end
```
## Normalized State
- This requires work but its just intentionally constructing the structure of the state in a meaningful way
- Main takeaway is that, if you choose to wait until after your framework is already built up, then you're going to have to change all of the references to the state (the action creators and the routers and everything in between
## Selectors
- Selectors can be built to structure how you get data from the db and clean up code in the render
- For example if you save all of the attribute info onto the object itself you won't have to write out a big function every time you want to access that attribute
