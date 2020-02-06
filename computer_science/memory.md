# Memory
- It may be valuable to imagine memory as if it were a bounded canvas with a finite number of slots.
  - It is very important to remember that **memory has a finite number of memory slots.**
- If your program needs more than one spot to store an object for some reason it would store that object in adjacent memory slots.
  - Your program will never try to store values where there are already values and it will search for somewhere where there are enough adjacent slots to store the desired value's type
- Memory is composed of bits. One memory spot can store 8 bits (a byte).
  - When you store memory in a spot you are storing a byte (8 bits)
  - Numbers are stored as binary numbers. (1 = 0000 0001, 2 = 0000 0010, 3 = 0000 0011)
  - Since integers are typically stored as 32 bit or 64 bit integers they will need 4 or 8 memory spots respectively.
  - Once the variables type has been set the variable will always take up that amount of memory. It will never change unless the variable's type changes.
- Strings are weird
  - Strings are mapped to numbers, i.e., ASCII code "A" -> 65, "B" -> 66
- Memory pointers
```javascript
// Memory canvas
00 01 02 03
04 05 06 07
08 09 10 11
12 13 14 15
16 17 18 19
```

