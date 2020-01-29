# Stacks and Queues
## Stack
- **LIFO** (Last-in first-out)
  - The most recent item added must be removed first
- Can be implemented using a linked list
Methods:
- `pop()` - Remove the top item & return it
- `push()` - Add item to top
- `peek()` - Return top item
- `isEmpty()` - Return true if the stack is empty
Time complexity:
- No constant-time index access
- Constant-time adds & removes
**Can often be used to implement a recursive algorithm iteratively**
## Queue
- **FIFO** (First-in first-out)
  - Items are removed in the same order that they are added
- Can be implemented using a linked list
- Often used when implementing a breath-first search
Methods:
- `add()` - Add an item to the end of the queue
- `remove()` - Remove the first item in the queue
- `peek()` - Return top item
- `isEmpty()` - Return true if the stack is empty

