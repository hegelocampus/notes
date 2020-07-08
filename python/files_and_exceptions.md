# Files and Exceptions
## Reading from a File
### Reading an Entire File
- The following program opens a file, reads it, and prints the contents of the file to the screen:

```python
with open('pi_digits.txt' as file_object:
  contents = file_object.read()
print(contents)
```
- To do any work with a file, even just printing its contents, you need to first open the file to access it.
  - The `open()` function needs one argument, the path of the file you want to open.
- The keyword `with` closes the file once access is no longer needed.
  - This is safer then the alternative of calling `open()` then `close()` when you are done with the file because an exception could prevent `close()` from ever being called, which can lead to file loss or corruption.

### Reading Line by Line
- You can use a for loop on the file object to examine each line from a file one at a time:

```python
with open(filename) as file_object:
  for line in file_object:
	print(line)
```
### Making a List of Lines from a File
- When you use `with`, the file object returned by open() is only available inside the `with` block. You can store the file's lines in a list inside the block and then work with that list outside the block:

```python
with open(filename) as file_object:
  lines = file_object.readlines()

for line in lines:
  print(line.rstrip())
```
### Large Files: One Million Digits
- Python is actually really chill with working with large files and you shouldn't need to take _too_ many special considerations beyond your system's own memory allocation.

## Writing to a File
### Writing to an Empty File
- To write text to a file, you need to call `open()` with a second argument telling Python that you want to write to the file.
- You can open a file in read mode (`'r'`), write mode (`'w'`), append mode (`'a'`), or read and write mode (`'r+'`)
  - Leaving the mode off will default to read mode.

```python
with open(filename, 'w') as file_object:
  file_object.write("I love programming.")
```
- You can call `write()` multiple times. Each call will append the passed in string to the end of the last. If you want multiple lines you will need to denote them yourself with a `\n`

### Appending to a File
- When you open a file in append mode, Python doesn't erase the contents of the file before returning the file object.
- Any lines you write to the file will be added at the end of the file.
```python
with open(filename, 'a') as file_object:
  file_object.write("I also love typing.\n")
  file_object.write("I also love learning languages in general.\n")
```
- If the file doesn't exist yet, Python will create an empty file for you.

## Exceptions
- When Python encounters a situation that produces an error. An exception object is created. That exception can be handled to keep the program running, otherwise the program will halt and a traceback of the error will be printed.
- Exceptions are handled in `try-except` blocks.
  - A `try-except` block asks Python to attempt something with special logic included to handle the potential case where an exception is raised.

```python
try:
  answer = int(first_number) / int(second_number)
except ZeroDivisionError:
  print("You can't divide by 0!")
else:
  print(answer)
```

## Storing Data
- You many want to store user data for use later. It is common to store this data is a JSON file.

### Using `json.dump()` and `json.load()`
- `json.dump()` takes two arguments: a pience of data to store and a file object it can use to store the data.
