# I/O in Python
## How the `input()` Function Works
- You can use the `input()` function to get user input:
```python
name = input("Please enter your name: ")
print(f"\nHello, {name}!")
```
- If you need to write a multi-line prompt it is often more clear to assign the string to a variable and then construct it over multiple lines:
```python
prompt = "If you tell us who you are, we can personalize the messages you see."
prompt += "\nWhat is your first name?

name = input(prompt)
```
- `input()` **will always return a string.** You need to use `int` to convert that sting to an int if you want to do math.
```python
age = input("How old are you? ")
age >= 18 # Throws a TypeError

age = int(input("How old are you? "))
age >= 18 # Properly evaluates
```

