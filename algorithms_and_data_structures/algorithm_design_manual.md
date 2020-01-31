# Algorithm Design Manual
## Part One: Practical Algorithm Design
### Introduction to Algorithm Design
Framing Questions:
- Are there bad algorithms? I.e., algorithms that are never right for any job?
- What makes an algorithm good?
Chapter notes:
- **An algorithm is a procedure to accomplish a specific task.** An algorithm is the idea behind any reasonable computer program.
- An algorithmic problem is specified by describing the complete set of _instances_ it must work on and of its output after running on one of these instances
  - E.g., the algorithmic problem of sorting:
	- _Problem:_ Sorting
	- _Input:_ A sequence of _n_ keys _a_<sub>1</sub>, ..., _a_<sub>n</sub>
	- _Output:_ The permutation (reordering) of the input sequence such that _a'_<sub>1</sub> <= _a'_<sub>2</sub> ... <= _a_<sub>n</sub>
  - Determining that you're dealing with a general problem is your first step towards solving it.
- An _algorithm_ is a procedure that takes any of the possible input instances and transforms it to the desired output.
Three desirable properties for a good algorithm:
  - It is _correct._
  - It is _efficient._
  - It is _easy to implement._
These goals may not simultaneously achievable.
#### Robot Tour
- Most popular idea idea is likely the _nearest-neighbor heuristic._
```
NearestNeighbor(P)
  Pick and visit an initial point p0 from P
  p = p0
  i = 0
  While there are still unvisited points
	i = i + 1
	Select pi to be the closest unvisited point to pi-1
	Visit pi
  Return to p0 from pn-1
```
  - Starting from one point you go to the closest neighbor. And then you go to the next nearest neighbor excluding the previously visited nodes.
  - **This algorithm is completely wrong.**
	- This algorithm always finds a tour, but not necessarily the shortest possible tour.
	- May end up jumping back and forth over already traveled distance in order to get to the next closest node.
- A different idea might be to repeatedly connect the closest pair of endpoints whose connection will not create a problem, such as a premature termination of the cycle.
```
ClosestPair(P)
  Let n be the number of points in set P.
  For i = 1 to n - 1 do
	D = infinity
	For each pair of endpoinst (S,T) from distinct vertex chains
	  if dist(S,T) <= D then Sm = S, Tm=T, and D = dist(S,S))
	Connect (Sm,Tm) by an edge
  Connect the two endpoints by an edge
```
  - This is almost like a merge sort algorithm. Creating sections that you then connect until you have a completed tour.
  - Somewhat more complicated and less efficient but at least it gives the right answer (most of the time).
  - **Also wrong as it fails to come to an optimal solution in some instances.**
- The correct algorithm would be to enumerate _all_ possible orderings of the set of points, and then select the ordering that minimizes the total length.
```
OptimalTSP(P)
  d = infinity
  For each of the n! permutations Pi of point set P
	If (cost(Pi) <= d) then d = cost(Pi) and Pmin = Pi
  Return Pmin
```
  - Since all possible orderings are considered, we are guaranteed to end up with the shortest possible tour.
  - Although this algorithm _is_ correct, it is also extremely slow.
  - The quest to solve this problem, called the _traveling salesman problem_ (TSP), will guide us through much of this book.
**There is a fundamental difference between _algorithms,_ which always produce a correct result, and _heuristics,_ which may usually do a good job but without providing any guarantee.**
### Algorithm Analysis
### Data Structures
### Sorting and Searching
### Graph Traversal
### Weighted Graph Algorithms
### Combinational Search and Heuristic Methods
### Dynamic Programming
### Intractable Problems and Approximation Algorithms
### How to Design Algorithms
## Part Two: The Hitchhiker's Guide to Algorithms
