# Linked List
- Represents a sequence of nodes, conceptually similar to an array
  - **Benefit over arrays is that the memory slots don't need to be sequential.** This allows for much greater flexibility over arrays, especially for large datasets.
- Varieties
  - Singly Linked List
	- Each Node points to the next node in the linked list
  - Doubly Linked List
	- Each Node points to both the next node and the previous node in the linked list
- Unlike an array, it doesn't provide constant time access to a particular "index"
- Benefit is that you can add and remove items from the beginning of the list in constant time.
- You often reference the list through the head node.
  - This can cause issues if your head node changes and there are multiple things pointing at the head node.
  - You can get around this problem by referencing the node via a wrapper `LinkedList` class that holds a single `head` instance variable.
- To delete a node you must find the previous node and then set the next node of that node equal to the next node of the node you want to delete.
  - Make sure you check for a `null` pointer, this will indicate you are at the end of the list
  - In C or C++ make sure you actually delete the node you want to remove so it doesn't leak memory.
- Runner iteration
  - Set up a second pointer to iterate through the list alongside the main one. One of the pointers should be ahead of the other.
  - This is meant to reduce time complexity.
## Space & Time complexity of common functions
### Get/set at index
- O(n) Time
  - You must iterate over each element of the list before the desired index 
- O(1) Space
  - No extra memory needed
### Initializing & Copying
- O(n) Time
  - You have to save each element in the list
- O(n) Space
  - Each element will need to be saved in memory
### Inserting
- O(1) Time
  - Although this will depend on additional context
	- You will need to know the current element at the desired insertion index. If you use an additional data structure to store the indexes of elements then you can do this in constant time.
	- Insertion at head will always be constant time.
- O(1) Space

