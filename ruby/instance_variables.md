# Class Instance Variables
- Because all classes are also objects, we can set instance variables for any class object
    ```ruby
    class Dog
      def self.all
        @dogs ||= []
      end

      def initialize(name
        @name = name

        self.class.all << self
      end
    end
    ```
- In the class method all we fetch/assign an instance variable dog. This stores
    the instance variable of the dog object itself, all dogs can be accessed
    through Dog.all
- Storing an instance variable on a class is called a **class instance
    variable**
## Inheritance: @@
- Class instance variables don't interact well with inheritance
e.g.,
    ```ruby
    class Corgi < Dog
    end
    ```
  - Here Corgi would inherent the #all method from dogs but would place all
      corgi objects into the @dogs instance variable that it does not have
      access to
  - If you need access to the same class instance variable of the parent class
      you can use @@
    - This is called a **class variable**
- Class variables(e.g., @@dogs) are shared between super-class and subclass
- You can probably just use @ until it doesn't work
## Global variables
- Global variables are prefixed with a $ and exist outside of any class and are
    accessible anywhere
- Global variables are permanent while class variables and class instance
    variables are cleaned up after the source file is executed
- Global variables should be avoided
- $stdin and $stdout are two global variables that are common, puts and gets are defined using them (respectively)
	- If you wanted to print to something other than the standard output you can use `print to console` or `print to ${a file}`
