# Classes
## Creating and Using a Class
### Creating a Dog Class
- By convention, capitalized names refer to classes in Python.
- The `__init__` method is Python's class initialization method that is called for each new class instance created.
  - The `self` parameter is required as the first parameter of all instance methods that take any parameters at all.

```python
class Dog:
  def __init__(self, name, age)
    # The variables defined below are named attributes. They are instance variables that are available to each method call.
	self.name = name
	self.age = age

  def sit(self):
	print(f"{self.name} is now sitting.")

  def roll_over(self):
	print(f"{self.name} rolled over!")
```
### Making an Instance from a Class
- Note how the attributes and methods can be accessed through dot notation on the instance.
```python
my_dog = Dog('Willie', 6)
print(f"My dog's name is {my_dog.name}.")
print(f"My dog is {my_dog.age} years old.")

my_dog.sit()
my_dog.roll_over()
```

- All python attributes have read write permission by default.
```python
my_dog = Dog('Willie', 6)
print(f"My dog's name is {my_dog.name}.") # Prints "My dog's name is Willie."

my_dog.name = 'Jared'
print(f"My dog's name is {my_dog.name}.") # Prints "My dog's name is Jared."
```

## Inheritance
### The __init__() Method for a Child Class
- When writing a new class based on an existing class, you'll often want to call the `__init__()` method from the parent class. This will initialize any attributes that were defined in the parent `__init__()` method and make them available in the child class. This is available through the special `super` function.
- You can override any method from the parent class. To do this, you define a method in the child class with the same name as the method you want to shadow in the parent class.

```python
class Car:
  def __init__(self, make, model, year):
	self.make = make
	self.model = model
	self.year = year
	self.odometer_reading = 0

  def get_discriptive_name(self):
	long_name = f"{self.year} {self.make} {self.model}"
	return long_name.title()

  def read_odometer(self):
	print(f"This car has {self.odometer_reading} miles on it.")

  def update_odometer(self, milage):
	if mileage >= self.odometer_reading:
	  self.odometer_reading = milage
	else:
	  print("You can't roll back an odometer!")

  def increment_odomoter(self, miles):
	self.odometer_reading += miles

class ElectricCar(Car):
  def __init__(self, make, model, year):
	super().__init__(make, model, year)
	self.battery_side = 75

  def describe_battery(self):
	print(f"This car has a {self.battery_side}-kWh battery."
```

### Instances as Attributes
- A common pattern is to abstract away detail of a class into a sub-class that is nested under an attribute
  - You would then access that sub-classes attributes through that attribute

```python
class Battery:
  def __init__(self, battery_size=75):
	self.battery_size = battery_size

  def describe_battery(self):
	print(f"This car has a {self.battery_side}-kWh battery."

class ElectricCar(Car):
  def __init__(self, make, model, year):
	super().__init__(make, model, year)
	self.battery = Battery()

my_car = ElectricCar('nissan', 'leaf', 2019)

print(my_car.get_descriptive_name())
my_car.battery.describe_battery()
```

## Styling Classes
- Class names should be written in _CamelCase_
- Every class should have a docstring immediately following the class definition. This should be a brief description of what the class does, and you should follow the same formatting conventions you used for writing docstrings in functions.

