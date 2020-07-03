# Functions in Python
- Python, like any reasonable language, throws an error when you have too many or too few arguments.

## Positional and Keyword Arguments
- Python allows for all arguments to be passed using either positional or keyword assignment.
- This isn't set in how the function is defined, you can do this just by changing the way you pass in the parameters when you call the function.

### Positional Arguments
- **Positional Arguments** are defined and accepted in a strict order, like you'd expect.

```python
def describe_pet(animal_type, pet_name):
  print(f"\I have a {anymal_type}.")
  print(f"My {animal_type}'s name is {pet_name.title()}.")

describe_pet('hamster', 'harry')
```

### Keyword Arguments
- These are name-value pairs that you pass to a function. You directly associate the name and the value within the argument. This allows for you to minimize ambiguity when passing the arguments to the function.

```python
def describe_pet(animal_type, pet_name):
  print(f"\I have a {anymal_type}.")
  print(f"My {animal_type}'s name is {pet_name.title()}.")

describe_pet(animal_type='hamster', pet_name='harry')
# Or
describe_pet(pet_name='harry', animal_type='hamster')
```

## Default Values
- Default values can be set with an `=` in the function definition:
```python
def describe_pet(pet_name, animal_type='dog'):
  print(f"\I have a {anymal_type}.")
  print(f"My {animal_type}'s name is {pet_name.title()}.")
```
- Default values should be set as the last arguments defined so that they can be safely omitted when the functions are called.

## Preventing a Function from Modifying a List
- Its common practice to send a copy of a list into a function to ensure it isn't modified. You can do this quickly withe the slice notation:
```python
function_name(list_name[:])
```

## Passing an Arbitrary Number of Arguments
- You can pass an arbitrary number of arguments to a function using the star (`*`) notation.
- This should always be the last parameter defined such that positional arguments can be passed prior to the tuple.
- This allows you to collect the remainder of the arguments to a tuple (even if it only represents a single value):
```python
def make_pizza(size, *toppings):
    print(f"\nMaking a size {size}-inch pizza with the following toppings:")
    for topping in toppings:
	  print(f"- {topping})
```

### Using Arbitrary Keyword Arguments
- You can create a map that collects keyword arguments using `**`
- If no extra arguments are passed this will represent an empty map
```python
def build_profile(first, last, **user_info):
	user_info['first_name'] = first
	user_info['last_name'] = last
	return user_info

user_profile = build_profile('albert', 'einstein',
							location='princeton',
							field='physics'
```
