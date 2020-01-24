# Metaprogramming and Reflection
## send and define_method
### reflection (introspection)
- We can ask an object what methods it will respond to:
    ```ruby
    obj = Object.new
    obj.methods #=> [:nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, ...]
    ```
- Can also call a method by name:
    ```ruby
    [].send(:count) #=> 0
    ```
- Can even define methods dynamically with define_method:
    ```ruby
    class Dog
      def self.makes_sound(name)
        define_method(name) { puts "#{name}!" }
      end
      
      makes_sound(:woof)
      makes_sound(:back)
    end

    dog = Dog.new
    dog.woof
    dog.bark
    dog.grr
    ```
  - This is called a macro
    - Macros are accessable by all objects w/in the class
- If a method is not found for an object then ruby calls #method_missing with
    any of the argumnts that were passed in the original call
  - This method can be overwrited for a class possibly with a #define_method
      call to define the missing method
  - Although this funtionality can be very useful it should be avoided because
      it can result in code that is very difficult to understand/debug
### Type Introspection
- This is finding class information
- In ruby even classes are objects
- All classes are instances of a Class class.
- Classes are types of Modules which is a subclass of object

