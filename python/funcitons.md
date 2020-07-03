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

## Modules
- Functions are grouped together into modules
- There are several ways to import modules when you need to access its functions.

This style imports all the functions into the current file namespaced under the module name:
```python
import pizza

pizza.make_pizza(16, 'pepperoni')
pizza.make_pizza(12, 'mushrooms', 'pepperoni', 'extra cheese')
```

### Importing Specific Functions
- You can only import specific functions too, using explicit imports
- This import style allows you to reference the functions without the module namespacing
```python
from module_name import function_name

function_name()
```
- You can import as many functions as you'd like using this syntax
```python
from module_name import function_0, function_1, function_2
```

### Aliasing using `as`
- You can import both functions and modules under an alias using the `as` keyword:

Function aliasing:
```python
from pizza import make_pizza as mp

mp(12, 'mushrooms', 'pepperoni', 'extra cheese')
```

Module aliasing:
```python
import pizza as p

p.make_pizza(12, 'mushrooms', 'pepperoni', 'extra cheese')
```
Aliasing modules is very common as it takes your attention away from the module name and allows you to focus on the descriptive function name. The general syntax for this approach is:
```python
import module_name as mn
```

### Importing All Functions in a Module
You can use the asterisk operation to import every function from a module:
```python
from pizza import *

make_pizza(12, 'mushrooms', 'pepperoni', 'extra cheese')
```
You should generally avoid this syntax because it leads to ambiguity as to where functions are defined, makes your code less readable, and can lead to function and variable names being shadowed. But, with that being said there are (rare) times where it is acceptable and you may find it in others code.
