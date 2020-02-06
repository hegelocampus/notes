# Trees and Graphs
## Trees
Core properties:
  - Each tree has a root node (Although not strictly necessary, but this is almost always the case in computer applications)
  - The root node has zero or more child nodes
  - Each child node has zero or more child nodes, and so on
Additional properties:
- Cannot contain cycles
- Nodes may or may not be in a particular order
- Children may or may not link back to the parent node
- A node is called a **leaf node** if it has no children
Watch out for the following:
- Trees vs. Binary trees
  - A binary tree is a tree in which each node has up to two children. **Not all trees are binary trees.**
  - Trees are named after the maximum number of children any nodes has.
- Binary Tree vs. Binary Search Tree
  - A binary search tree is a binary tree in which every node fits a specific ordering property.
	-  `All left descendants <= n < all right descendents`
	- This should be true of **all** the node's descendants, not just its direct children
  - Definitions vary on equality in binary search trees. **Make sure to clarify which definition you should use**
	- Some believe that the tree cannot have duplicate values.
	- Others hold that duplicate values will be on the right or can be on either side.
- Balanced vs. Unbalanced
  - While many trees are balanced, not all are. **Ask for clarification**
  - Balanced doesn't mean that the left and right subtrees are exactly the same size.
	- Balanced really means more like "not terribly imbalanced
    - Should be balanced enough to ensure `O(log n)` insert and find time complexity, but not necessarily as balanced as it could be
  - Common types of balanced trees:
	- Red-black trees(pg 639)
	- AVL trees(pg 637)
## Types of Binary Trees:
- Complete Binary Trees
  - A binary tree in which every level of the tree is fully filled except for perhaps the last level.
  - The last level should be filled from left to right
- Full Binary Trees
  - Every node has either zero or two children.
  - No nodes should have only one child.
- Perfect Binary Tree
  - All interior nodes have two children.
  - All leaf nodes are at the same level
  - Very rare. **Never assume a binary tree is perfect**
## Binary Tree Traversal:
- You should be comfortable implementing in-order, post-order, and pre-order traversal. In-order is the most common of these.
### In-order
- Visit the left branch, then the current node, and finally the right branch.
```dart
void inOrderTraversal(Node node) {
  if (node != null) {
	inOrderTraversal(node.left);
	visit(node);
	inOrderTraversal(node.right);
  }
}
```
### Pre-order
- Visit the current node before its children.
- The root is always the first node visited.
```dart
void preOrderTraversal(Node node) {
  if (node != null) {
	visit(node);
	inOrderTraversal(node.left);
	inOrderTraversal(node.right);
  }
}
```
### Post-order
- Visits the current node after its children.
- The root is always the last node visited.
```dart
void postOrderTraversal(Node node) {
  if (node != null) {
	inOrderTraversal(node.left);
	inOrderTraversal(node.right);
	visit(node);
  }
}
```
Example `Node`:
```dart
class Node {
  List<Node> nodes = [];
  var value;
}
```

