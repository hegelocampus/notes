# Logarithm
- log<sub>b</sub>(x) = y iif b<sup>y</sup> = x
  - Log always needs a base, that is represented by the `b` here, in computer science we always assume that the base is 2
  - Log of N is thus the power by which we need to raise the base to to get N
	- log(1) = 0 -> 2<sup>0</sup> = 1
	- log(4) = 2 -> 2<sup>2</sup> = 4
	- log(16) = 4 -> 2<sup>4</sup> = 16
	- log(32) = 5 -> 2<sup>5</sup> = 32
	- log(1M) = 20 -> 2<sup>20</sup> = >1M
- Powers of two:
  - Each power of two is doubled.
  - Even when 2 is gigantic the N is log(n) will be a relatively small number
- All of this should show that a time complexity of O(log(n)) is actually incredibly good.
- **Algorithms that have a O(log(n)) time complexity tend to cut the data set in half with each iteration**. Ask yourself if you are cutting the size of the data in half each time. You can also think about what would happen with a massive amount of data, how many operations would you need?
  - Binary search
  - Binary trees
  - Min-Max Heaps

