# Learn You Haskell for Great Good
## Intro
### What's Haskell?
*Haskell is a Purely functional programming language*  
This is defined through negation
- Imperative languages
  - Complete tasks through giving the computer a sequence of tasks and then executing them.
  - While executing them it can change state. E.g., you can set variable `a` to one thing and then at a later point set it to something else.
  - You have structures to control how many times an action is performed.
- Functional languages
  - You don't tell the computer what to do, but rather tell it what stuff _is_.
    - For example, a factorial is the product of all the numbers form 1 to that number, the sum of a list of numbers is the first number plus the sum of the rest of the list.
    - You express these definitions in the form of a function.
  - You can't set a variable to something and then change it later.
  - A function has no side effects, none of the input values are ever changed.
  - All a function does is calculate something and return it as a result.
  - **Referential Transparency: If you call a function twice with the same parameters you're guaranteed to get the same result**
What Haskell is:
- Lazy
  - It won't execute functions unless you force it to tell you a result.
  - This allows you to think of functions are a series of transformations on data.
  - Allows for infinite data structures.
  - Only passes through the data when it actually needs to, allowing for reduced time complexity.
- Statically typed
  - The compiler knows which pieces of the code are what data types.
  - A lot of possible errors are caught at compile.
  - Has *type inference*. So you don't have to explicitly label every variable.
- Elegant and concise
  - Programs are usually shorter than their imperative equivalents.
  - Shorter programs are easier to maintain and have less bugs.
Haskell Platform
- GHC is the most widely used Haskell compiler.
  - Interactive mode using `ghci`
  - Load a file using `:l foo` in the directory containing `foo.hs`. Run the command again if you change the file or do`:r`
### Starting Out
- Make sure to wrap negative numbers in parenthesis, do `5 * (-3)` not `5 * -3`
- Boolean algebra is what you'd expect
  - `&&` for bool _and_
  - `||` for bool _or_
- You can use `not` to negate `True` or `False`
- Testing for equality is what you'd expect
  - `==` for equality
  - `/=` for not equal, **new & weird**
- operators only work on number (as they should)
  - `5 + "llama"` will throw an error
  - so will `5 + '5'`
- You can only compare objects that can be compared
  - i.e., objects that have types that match up.
  - `True == 5` won't work
- **Integers are weird and are always both integers and floating-point numbers, but floating-point numbers are always floating-point numbers**
#### Functions
- Functions are called by writing the function name, a space and then the parameters, each separated by a space, e.g.,
  - `succ 8` returns `9`
  - `min 9 10` returns `9`
  - `min 3.4 3.2` returns `3.2`
  - `max 100 101` returns `101`
- If a function takes two arguments you can call it as an **infix function** by surrounding it with backticks, e.g.,
  - `div` takes two integers and does integral division between them, you can just do `div 92 10` but its a little less clear which number is acting on the other
  - For clarity you can do ``92 `div` 10``
Function application has the highest precedence so the following are equivalent:
```haskell
succ 9 + max 5 4 + 1
16
(succ 9) + (max 5 4) + 1
```
##### Defining functions
- Functions are defined in a way similar to how they are called 
```haskell
doubleMe x = x + x
```
**A common pattern in Haskell is to make basic functions that are obviously correct and then combining them into more complex functions**
- Functions in Haskell don't have to be defined before they are used are defined (in JS terms they are hoisted)
- the `'` has no special meaning in Haskell syntax, but it is usually used in function names to denote a strict version of a function (i.e., one that isn't lazy), or a slightly modified version of a function or variable
- Functions can't begin with capital letters
###### Conditionals in functions
- The `else` statement is mandatory in Haskell
- An expression is a piece of code that returns a value.
  - `5` is an expression because it returns `5`
  - `4 + 8` is an expression
  - An `if` statement is an _expression_, because of this you need the else statement so that it can return something.

```haskell
doubleSmallNumber x = if x > 100
						then x
						else x*2
```
#### Lists
- Strings are lists in Haskell
  - `"hello"` is equivalent to `['h','e','l','l','o']`
  - You can use List functions on strings
- Lists are always always **homogeneous**
- Lists are denoted by square brackets, like normal, e.g., `[4,8,15,16,23,42]`
- You can add two lists together using `++`, e.g., `"hello" ++ " " ++ "world"` 
  - Be careful using `++` on long strings because Haskel has to walk through the entire list on the left side of the `++`
- You can put something at the beginning of a list instantaneously using the `:` operator (cons operator)
  - `'A':" SMALL CAT"` returns `"A SMALL CAT"`
  - `5:[1,2,3,4,5]` returns `[5,1,2,3,4,5]`
- `[1,2,3]` is actually just syntactic sugar for `1:2:3:[]`, where `[]` is an empty list.
- You can use `!!` to fetch an item from a list via its index
  - `"Steve Buscemi" !! 6` returns `B`
  - Make sure not to ask for an index that doesn't exist, this will throw an error
- Lists can contain lists to create multidimensional lists
  - These sub-lists can be different lengths but not different types
- Lists can be compared if they contain stuff that can be compared
  - The items they contain are compared in lexicographical order, e.g., the heads are compared first and then the next items are compared if the heads are equal and so on and so forth
- Some more basic list functions
  - `head` takes a list and returns its head
  - `tail` takes a list and returns everything but its head
  - `last` takes a list and returns its last element
  - `init` takes a list and returns everything but its last element
  - **All of the above will throw an error if passed an empty list**
  - `length` takes a list and returns its length
  - `null` checks if a list is empty and returns a boolean, its best practice to use this rather than `foo == []`
  - `reverse` returns a reversed version of the list
  - `take` takes a number and a list, it extracts that many elements form the beginning of the list
	- If you try to take more elements than there are in the list it just returns the list.
	- If you try to take 0 elements it returns an empty list
  - `drop` works in a similar way to `take` but drops the given number from the beginning of the list
  - `maximum` takes a list of stuff that can be ordered and returns the biggest element
  - `minimum` takes a list of stuff that can be ordered and returns the smallest element
  - `sum` takes a list of numbers and returns their sum
  - `product` takes a list of numbers and returns their product
  - `elem` takes a thing and a list of things and returns a bool indicating if the list contains the thing, usually called as an infix function for readability, e.g., ``4 `elem` [3,4,5,6]`` returns `True`, ``10 `elem` [3,4,5,6]`` returns `False` 
##### Ranges
- You can create a list from 1 to 20 using `[1..20]`, and a to z using `['a'..'z']` (hell yeah)
- You can perform magic in Haskell, `[2,4..20]` returns `[2,4,6,8,10,12,14,16,18,20]`
  - Here a pattern is being defined by which the range will be constructed
  - To get a reverse range you have to do `[20,19..1]` rather than `[20..1]`
  - Although there are some limitations:
	- You can only define a single step, so you can't do powers
	- Floating point numbers can get funky because the numbers are not completely precise. You probably should just avoid using them in list ranges
- You can also use ranges to make infinite lists by not specifying an upper limit, e.g., `[13,26..]`
  - You can even use these because Haskell is lazy and will only evaluate the numbers you need. For example, `take 24 [13, 26..]` will only take/calculate the first 24 multiples of 13
- Some functions that produce infinite lists:
  - `cycle` takes a list and cycles it into an infinite list
  - `repeat` takes an element and produces an infinite list of just that element
	- Although it is generally simpler to use `replicate n "foo"` to get a list of n "foo"'s
##### List comprehensions
You can build comprehensions to build specific sets of numbers, for example, `[x*2 | x <- [1..10]]` will create a list of the first 10 even numbers.  
You can build on this by adding a condition (or predicate) to that comprehension. For example say we only want the elements which, when doubled are greater than or equal to 12.
```haskell
ghci> [x*2 | x <- [1..10], x*2 >= 12]
[12,14,16,18,20]
```
- Weeding out lists by predicates is also called **filtering**
Replace each odd number greater than 10 with `"BANG!"` and each odd number less than 10 with `"BOOM!"`, and if a number isn't odd we throw it out of the list.  
For convience we'll put the comprehension inside a function:
```haskell
boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
ghci> boomBangs [7..13]
["BOOM!","BOOM!","BANG!","BANG!"]
```
You can even pass in several predicates. For example for all numbers from 10 to 20 that are not 13, 15 or 19:
```haskell
ghci> [ x | x <- [10..20], x /= 13, x /= 15, x /= 19]  
[10,11,12,14,16,17,18,20]  
```
- **An element must satisfy all the predicates to be included in the list**
- To get all the possible combinations of the items in two lists you can do the following:
```haskell
ghci> [ x*y | x <- [2,5,10], y <- [8,10,11]]  
[16,20,22,40,50,55,80,100,110]   
```
- You can even use this to count occurrences, this counts the number of odd elements
```haskell
ghci> sum [ 1 | x <- [1,2,3,4,5], odd x]]
3
```
#### Tuples
```haskell
let tuple = (8, 11, 5)
```
- Tuples are used when you know exactly how many values you want to combine and its type depends on how many components it has and the types of the components.
- Tuples **don't have to be homogeneous** and can contain several types
- A tuple of size two (called a pair) is its own type so you can't have a list contain a couple of pairs and a triple (a tuple of size three).
- Because of this, a list like this would result in an error:
```haskell
[(1, 2), (8, 11, 5), (4, 5)]
```
- You also can't create a list of Tuples of different types:
```haskell
ghci> [(1,2),("One",2)]
error
```
- A good example of a place where a tuple makes sense is to represent a person's name and age: `("Christopher", "Walken", 55)`
- You should only use Tuples when you know in advance how many components some piece of data should have. Tuples are much more rigid than lists. You cannot write a general function to append an element to a tuple, you'd have to write a function for appending to a pair, to a triple, and for a 4-tuple, and so on.
- You can compare two tuples of the same size but not of different size. They are compared in the same way as lists, with each element being compared in order
- Useful pair tuple functions
  - `fst` takes a pair and returns its first component
  - `snd` takes a pair and returns its second component
  - **Note these only work on pairs**
- You can use `zip` to take two lists and zip them together in one list joining the matching elements into pairs
  - You can even zip lists of different lengths, the longer list will simply get cut off to match the length of the shorter one
```haskell
ghci> zip [1 .. 5] ["one", "two", "three", "four", "five"]  
[(1,"one"),(2,"two"),(3,"three"),(4,"four"),(5,"five")]  
```
### Types and Typeclasses
- In GHCI you can use `:t` to examine the type of the expression following it.
For example:
```haskell
ghci> :t 4 == 5  
4 == 5 :: Bool 
```
- Explicit types are always denoted by the first letter being capitalized, e.g., `Char`, `Bool`, `False`
- **Functions also have types**
  - When writing functions you can choose to give them an explicit type declaration. This is best practice for everything except very short functions.
Here's how you declare the type of a function:
```haskell
removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]
```
- In this example `[Char] -> [Char]` means that it takes in a string and returns a string (The `[Char]` type is synonymous with `[String]`, so its clearer to write `String -> String`)
- To define multiple parameters you would separate each parameter with a `->`, e.g., `Int -> Int -> Int -> Int` the last value will always be the return value
#### Common Types
- `Int` is an integer.
  - Used for Whole numbers.
  - Is bounded. On 32-bit machines typically has a max value of 2147483647 and minimum of -2147483648. 
- `Integer` is also used for integers but **these are not bounded**, should only be used for huge numbers because its not very efficient.
- `Float` is a real floating point number with single precision.
- `Double` is a real floating point number with double precision.
- `Bool` is the boolean type. It only has one of two values: `True` or `False`
- `Char` represents a character. It's denoted by single quotes. A list of characters is a string.
- Tuples are also types but their type is dependent on their length and components
##### Type Variables
- A **type variable** can be of any type.
- These are used to write very general functions if you don't use any behaviors specific to any specific type.
- Functions that have type variables are called **polymorphic functions**
- Type variables are usually given the names of `a`, `b`, `c`, `d` ...
#### Typeclasses
- A typeclass is a sort of interface that defines some behavior.
- If a type is a part of a typeclass, it supports and implements the behavior the typeclass describes.
- These are **not like classes in OOP**
- A **class constraint** is denoted by a `=>` symbol
  - For example `:t (==)` returns this type: `(Eq a) => a -> a -> Bool`, in this type `(Eq a) =>` is declaring that the variable `a` must be in the `Eq` class. This particular typeclass provides an interface for testing equality
##### Common typeclasses
- `Eq` is used for types that support equality testing. If there's an `Eq` class constraint that means it uses `==` or `/=` somewhere in its definition.
- `Ord` is for types that have an ordering. `Ord` membership requires `Eq` membership
- `Show` members can be presented as strings. The most common function for this typeclass is `show` which takes a value and presents it as a string.
- `Read` is kind of the opposite of `Show`. The `read` function takes a string and returns a type which is a member of `Read`
  - If you want to use read on a object that can be converted into multiple types you can declare the type as follows: 
```haskell
ghci> read "5" :: Int
5
ghci> read "5" :: Float
5.0
ghci> read "[1,2,3,4]" :: [Int]  
[1,2,3,4]
```
You shouldn't need to do this for most expressions but if the compiler can't figure our what the type of something is you may need to do this.
- `Enum` members are sequentially ordered types
- `Bounded` members have an upper and a lower bound. `Int`, `Char`, `Bool`
- `Num` is a numeric typeclass. Its members can act like numbers. `Int`, `Integer`, `Float`, `Double`
- `Integral` is also a numeric typeclass. `Num` includes all numbers, including real numbers and integral numbers, `Integral` only includes integral numbers. `Int` and `Integer`
- `Floating` includes only floating point numbers. `Float` and `Double`
A very useful function for dealing with numbers is `fromIntegral`. It takes an integral number and turns it into a more general number.
## Syntax in Functions
### Pattern Matching
- Pattern matching allows you to specify patterns to which some data should conform. You can then check the data against that pattern to see if it does and even deconstruct the data according to the pattern.
- You can define separate function bodies for different patterns.
- You can pattern match on any data type.
Trivial example:
```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVER!"
-- x Defines the default case, if this were defined first it would never hit the 7 case
lucky x = "sorry, you're out of luck, pal!"
```
- When you call a pattern matching function such as this one the patterns will be checked from top to bottom. When a pattern is found, the corresponding function body is called. Otherwise it falls through to the following pattern.
- You can do normally do the same things as you can with patterns with if statements, but patterns are generally much more elegant.
- **If your pattern match doesn't find a match it will raise an exception**
- You can even pattern match in list comprehensions:
```haskell
ghci> let xs = [(1,3), (4,3), (2,4), (5,3), (5,6), (3,1)]  
ghci> [a+b | (a,b) <- xs]  
[4,7,6,8,11,4]   
```
- When used in this way if the pattern match were to fail, it would just move on to the next element.
- A particularly useful pattern is `x:xs` it will match lists of more than 1 in length. `x` would represent the first element and `xs` would be the rest of the list.
- There are also _patterns_ 
  - These allow you to break something up according to a pattern and bind it to names while still keeping reference to the whole thing.
  - This is done by prepending a `@` to the pattern, e.g., `xs@(x:y:ys)`. This pattern would match. Heres a good example of how you can use this:
```haskell
capital :: String -> String  
capital "" = "Empty string, whoops!"  
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x] 
capital "Dracula" -- "The first letter of Dracula is D"  
```
### Guards
- Guards are a way of testing whether some property of a value are true or false. 
- These are also similar to if statements. They, like pattern matching, tend to be much more readable than if statements. Especially if you have several conditions. Guards also work great with patterns.
An Example:
```haskell
bmiTell :: (RealFloat a) => a -> String  
bmiTell bmi  
  | bmi <= 18.5 = "You're underweight, you emo, you!"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= 30.0 = "Your a little overweight my guy!"
  | otherwise   = "Big boi!"
```
- Like pattern matching, this check is done in order, from top to bottom.
- A guard is essentially a boolean function where if the function matches the corresponding function body is used, else it drops through to the next guard.
- The last guard is typically `otherwise`, otherwise is just defined as `otherwise = True` so that it will always trigger the 
You can also define these as function that take as many parameters as you want, of course.
```haskell
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height
  | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"
  | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | weight / height ^ 2 <= 30.0 = "Your a little overweight my guy!"
  | otherwise   = "Big boi!"
```
### Where
You can use `where` to dry up your code by defining a variable for use in the function
```haskell
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height
  | bmi <= 18.5 = "You're underweight, you emo, you!"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= 30.0 = "Your a little overweight my guy!"
  | otherwise   = "Big boi!"
  where bmi = weight / height ^ 2
```
You can even define multiple variables:
```haskell
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height
  | bmi <= skinny = "You're underweight, you emo, you!"
  | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= fat = "Your a little overweight my guy!"
  | otherwise   = "Big boi!"
  where bmi = weight / height ^ 2
		skinny = 18.5
		normal = 25.0
		fat = 30.0
```
- The variables defined within `where` are only visible to that function.
- All the names need to be aligned to column for Haskell to understand them.
- You can also use where binding to pattern match. The previous block can be rewritten as follows:
```haskell
...
where bmi = weight / height ^ 2
	  (skinny, normal, fat) = (18.5, 25.0, 30.0)
```
You can even use where blocks to define helper functions:
```haskell
calcBmis :: (RealFloat a) => [(a, a)] -> [a]  
calcBmis xs = [bmi w h | (w, h) <- xs]  
  where bmi weight height = weight / height ^ 2  
```
- Where bindings can even be nested if you want to get a little wild. Its actually a fairly common idiom.
### Let Bindings
