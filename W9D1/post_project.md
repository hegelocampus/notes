- You can do any query in any class from any action
- E.g., you don't have to only do users table modification from the `UsersController`
The `#update` method should have looked something like this:
```ruby
def update
  superhero = Superhero.find_by(id: params[:id])

  if superhero.update(superhero_params)
    render json: superhero
  else
    render json: superhero.errors.full_messages, status: :unprocessable_entity
  end
end

def superhero_params
  params.require(:superhero).permit(:name, :secret_identity, :power)
end
```
