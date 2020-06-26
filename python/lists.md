# Lists in Python
- Square brackets indicate a list, and individual elements in the list are separated by commas.
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
