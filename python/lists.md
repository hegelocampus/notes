# Lists in Python
- Square brackets indicate a list, and individual elements in the list are separated by commas.
- You can also create lists by calling `list()` on an iterable object, e.g., `list(range(1, 5))` would create the following list: `[1, 2, 3, 4]`
```python
bicycles = ['trek', 'cannondale', 'redline', 'specialized']
print(bicycles)
```
- Python allows you to access items at the end of a list by using a negative index lookup:
```python
bicycles = ['trek', 'cannondale', 'redline', 'specialized']
# This prints 'specialized'
print(bicycles[-1])
# This prints 'redline'
print(bicycles[-2])
```
- Lists are mutable and you can add, remove, and change elements
```python
motorcycles = ['honda', 'yamaha', 'suzuki']
motorcycles[0] = 'ducati'
# motorcycles is now: ['ducati', 'yamaha', 'suzuki']

motorcycles.append('honda')
# motorcycles is now: ['ducati', 'yamaha', 'suzuki', 'honda']

del motorcycles[1]
# motorcycles is now: ['ducati', 'suzuki', 'honda']

last_motorcycle = motorcycles.pop()
# motorcycles is now: ['ducati', 'suzuki']
# last_motorcycle is: 'honda'
```

- You can use pop to remove an item at any index by passing the index to `pop()`
```python
motorcycles = ['honda', 'yamaha', 'suzuki']
first = motorcycles.pop(0)
# First is honda, motorcycles now contains ['yamaha', 'suzuki']
```

- You can remove an item who's position you do not know using the `remove()` method
  - This method deletes only the first occurrence of the value in the list. If you want all values removed from the list you would have to do this in a loop.
```python
motorcycles = ['honda', 'yamaha', 'suzuki', 'ducati']
motorcycles.remove('ducati')
# First is honda, motorcycles now contains ['honda', 'yamaha', 'suzuki']
```
- Python's `sort()` method will sort the list in place

## List Comprehensions
- Python also allows you to create lists using list comprehensions
```python
squares = [value ** 2 for value in range(1, 11)]
print(squares) # Prints [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

## Working with Part of a List
- Python has special syntax for slicing. You specify the first and list elements you want to work with in brackets:
```python
players = ['charles', 'martina', 'michael', 'florence', 'eli']
print(players[0:3]) # Prints ['charles', 'martina', 'michael']
```
- You can omit the first index in the slice and Python will assume a starting index of 0.
```python
print(players[:3]) # Prints ['charles', 'martina', 'michael']
```
- You can also omit the second index and Python will slice the first index through the end of the list.

### Copying a list
- You can copy a list using the same syntax but omitting the starting and ending syntax:
```python
my_foods = ['pizza', 'falafel', 'carrot cake']
friend_foods = my_foods[:]
```

# Tuples
- Tuples are, en essence, immutable lists
- Tuples look just like lists except they use parentheses instead of square brackets.
- Once a tuple is defined you can access each element by its index, just like lists.
- Tuples are technically defined by the presence of a comma; the parentheses are just added to make them look cleaner and more readable. **If you want to define a tuple with just one element, you need to include a trailing comma.**
  - It doesn't often make sense to create a tuple with one element, but this can happen when tuples are generated automatically.
- Although tuples are internally immutable, the variable that they are stored at can still be redefined:
```python
dimensions = (200, 50)
print(dimensions) # Prints (200, 50)
dimensions = (400, 100)
print(dimensions) # Prints (400, 100)
```
