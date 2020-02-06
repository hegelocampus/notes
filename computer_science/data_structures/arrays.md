# Arrays
## Arrays in memory
- All elements in the array are converted into binary and then the OS finds a section of the memory that the **entire** array can fit into. For instance an array of 3 integers would take up 24 memory slots.
- Static Array
  - Array length is **fixed,** once its set it can not change without creating a new array.
- Dynamic Array
  - Array length is **variable** and can change over time.
  - JavaScript and Python both use dynamic arrays by default
  - This depends on the language you are using but typically the array allocates twice the space you actually need, with the second half filled with empty memory spots that can be filled at a later time without having to repartition the entire array.
## Common operations
### Access element (`arr[i]`)
  - O(1), Constant time
  - This access time is due to how the array is stored in memory.
	- Because the array knows the size of each element in the array, it can quickly and easily determine exactly where in the memory group the desired element is.
  - Sequence of events
	- OS finds the memory address that starts the array.
	- Then determines how many bytes each element takes up.
	- Then determines the index of the desired element.
	- Then does math to determine the desired memory slot.
### Set an element (`arr[i] = 5`)
  - O(1), Constant time
  - Memory slot is immediately determined and then the new value is set.
	- As long as the value's data size is the same nothing has to change.
### Initialize
  - O(n)
  - OS must find a memory spot that is large enough to hold the entire array. This requires that it determines the size of each element in the array.
### Traverse
  - O(n)
  - Space complexity depends on if the operation is happening in place or not
### Copy
  - O(n), time and space
  - Read each block and write a new one for each
  - **Relatively expensive operation**
### Insert (anywhere in the array)
  - In order to insert a new value you need to shift every block after the insertion point.
  - Static arrays
	- O(N) time, O(1) space
	- The OS must find a new memory block for the array because the memory
  - Dynamic arrays
	- O(1), Constant time
	- Because the array always has twice the size it actually needs it will, on average, have constant time insertion. The O(N) insertions get canceled out because most of the insertions are O(1)
### Pop (remove the value at the end)
  - O(1)
  - You are only ever removing from a spot that is accessible in constant time

