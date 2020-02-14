# Hash Tables
- Every key maps onto a value in a set of data values
- Fairly complicated under-the-hood
  - Built on top of an array
  - When you insert a key value pair in a hash-table you **transform the key into an index for the stored value** using a hashing function. This allows you to lookup the value in constant time.
  - There is a chance that two values will hash into the same value. This is determined by the complexity of the hashing function. This is know as a hash **collision**
	- This is solved by having each index in the array actually point at a linked list. E.g., `[listOne{ 2 }, listTwo{ }, listThree{ 1 -> 2 -> 3 }]`
  - When the array is gets to a certain degree of being filled it will actually resize and run all the elements in the array into a new hashing function that will be used from there on to access the values. This is done to further prevent hash collisions.
## Time and Space Complexity
### Insert, delete, and search
- O(1) Time
  - Hash Table worst case time complexity is Linear time if all keys collide because of this. You can really forget about this because most hashing functions are great and don't cause collisions. Just keep this in mind if the interviewer notes that the data look-up **really** needs to always be constant time in all cases.
  - Also the hashing function itself may not have constant time but we don't care about that because modern hashing functions are great.

