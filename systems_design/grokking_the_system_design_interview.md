# Grokking the System Design Interview Notes
## Key Characteristics of Distributed Systems
### Scalability
- **Scalability** is the capability of a system, process, or a network to grow and manage increased demand.
  - Any system that can evolve and flex to fit the current requirements over a period of time is considered scalable.
- A system may have to scale for a number of reasons:
  - Increased data volume
  - Increased amount of work (number of transactions)
- A scalable system aims to achieve increased requirements without performance loss
- Generally the performance of a system, even in systems that are designed to be scalable, tends to degrade over time.
- A scalable system avoids performance loss through attempting to balance the needed load across all participating nodes evenly
#### Horizontal vs. Vertical scaling
- **Horizontal scaling:** adding more servers
  - Able to scale dynamically by simply adding or removing servers from an existing pool
  - Doesn't require downtime
- **Vertical scaling:** adding additional power to an existing server
  - Harder to scale dynamically
  - Often requires downtime

### Reliability
- **Reliability** is the probability a system will fail in a given period
  - A system is reliable if it is able to continue delivering its services even when one or several of its software or hardware components fail
- This is often very important because it is typically assumed that systems will not fail and it can cause issues with customers when services fail.
- Systems typically achieve reliability through redundancy of both its software components and data. **If a system fails there should a backup system with the exact data on the original system to replace it**

### Availability
- **Availability** is the time a system remains operational to perform its required function in a specific period.
  - Any system that operational for the majority of the time with very little downtime for maintenance can be said to be highly available
  - Takes into account maintainability, repair time, spares availability, and other logistical considerations.
- Reliability is availability over time considering possible real-world conditions that can occur.
#### Reliability vs. Availability
- If a system is reliable, it is available.
- If a system is available it is **not necessarily reliable**
- High reliability contributes to high availability, but it is possible to achieve high availability even with an unreliable product if minimize repair time and ensure spares are always available when needed.

### Efficiency
- **Efficiency** has two standards, given an operation that runs in a distributed manner and delivers a set of items as result:
  - **Response time (or latency)** - the delay to obtain the first item
  - **Throughput (or bandwidth)** - the number of items delivered in a given time unit.
- These two measures correspond to the following unit costs:
  - The number of messages globally sent by the nodes of the system regardless of the message size.
  - Size of messages representing the volume of data exchanges.
- The complexity of operations supported by distributed data structures (e.g., looking for a specific key in an index) can be characterized as a function of one of these cost units.

### Serviceability or Manageability
- **Serviceability** is how easy the system is to operate and maintain. 
- This will have a major impact on availability, as a system that takes a lot of time to repair will be less available.
- Things to consider are:
  - Ease of diagnosing and understanding problems
  - Ease of making updates or modifications
  - How simple it is to operate
- The best way to avoid system downtime is through early detection of faults
## Load balancing
- The **Load Balancer (LB)** spreads the incoming traffic across the cluster of servers to improve responsiveness and availability of applications, websites, or databases.
- The LB also keeps track of the status of all the resources while distributing requests. If a server is not available to take new requests, the LB will stop sending traffic to that server.
- It will typically sit between the client and the server. It distributes the traffic using various weighted algorithms.
- A LB reduces the loads of individual servers and prevents any one server from becoming a single point of failure. A LB will improve overall application availability and responsiveness.
- LBs can be added at three places:
  - Between the user and the web server
  - Between the web servers and an internal platform layer (e.g., application servers or cache servers)
  - Between the internal platform layer and the database
```
		   /-> Web Server -\	 /-> Application Server -\     /-> Database
client->LB-					->LB-					      ->LB-
		   \-> Web Server -/	 \-> Application Server -/     \-> Database
```
### Benefits
- Users experience faster, uninterrupted service. If a server is struggling to complete their task, the task is passed to a more readily available server.
- Service providers experience less downtime and higher throughput.
- Load balancing makes it easier for system admins to handle incoming requests
- Smart load balancers provide predictive analytics that predict traffic bottlenecks before they can happen.
- System admins experience fewer failed or stressed components.
### Load Balancing Algorithms
- How does the load balancer choose the backend server to route a request to?
  - First ensure that the server they choose is actually responding appropriately to requests.
  - Then uses a pre-configured algorithm to select from the set of healthy servers.
- **Health Checks** - Attempt to connect to backend servers to ensure that servers are listening. If a server fails a health check it is removed from the pool of healthy servers until it is pinged and successfully responds.
- **Load balancing methods**
  - **Least Connection Method** - Directs traffic to the server with the fewest active connections. Useful when there are a large number of persistent client connections which are unevenly distributed between the servers
  - **Least Response Time Method** - Directs traffic to the server with the fewest active connections **and the lowest average response time**.
  - **Least Bandwidth Method** - Directs traffic to the server that is currently serving the least traffic as measured in megabits per second (Mbps).
  - **Round Robin Method** - Directs traffic sequentially through a list of servers. Most useful when the servers are of equal specification and there are not many persistent connections.
  - **Weighted Round Robin Method** - Each server is assigned a weight. Servers with higher weight receive new connections before those with less weight. Thus servers with higher weights get more connections than those with less weights.
  - **IP Hash Method** - A hash of the IP address of the client is calculated to redirect to a particular server.
### Redundant Load Balancers
- Because the load balancer can be a single point of failure, this is oven overcome by adding a second load balancer, forming a cluster of load balancers that have their health monitored. In the event that the main load balancer fails, the auxiliary load balancer can take over.

## Caching
- Caching enables the system to make vastly better use of the resources it already has, as well as making otherwise unattainable product requirements feasible.
- Recently fetched data is likely to be requested again, so it is often beneficial to store that data in memory so it can be subsequently fetched faster.
- Caches can exist at all levels in architecture, but are **often found at the level nearest to the front end** where they are implemented to return data quickly without taxing downstream levels.
### Application server cache
- Placing a cache on a request layer node enables the local storage of response data.
- Each time a request is made, the node quickly returns local cached data if it exists. It is only when the data is not cached that the requesting node will query the data from the database
- This cache can be located both in memory (very fast) and on the node's local disk (faster than network storage).
- If you have multiple notes each node can still have its own cache, However, depending on the load balancer's distribution method this may lead to a cache not being utilized so this should be taken into consideration when choosing the cache's location and the distribution method.
### Content Distribution Network (CDN)
- These are useful for sites serving large amounts of static media.
- In a typical CDN: 
  - A request will first ask the CDN for a piece of media
  - The CDN will serve that content if it has it locally available
  - If it isn't available, the CDN will query the back-end servers for the file, cache it locally, and serve it to the requesting user.
- If the system isn't yet large enough to have its own CDN, you can make the future transition easier by serving the static media off a separate subdomain (e.g., static.foo.com). This way you will simply have to have the DNS lookup changed for the subdomain when it becomes feasible to add a CDN.
### Cache Invalidation
- Caching does require some maintenance in order to keep the content up to date with the source of truth (e.g., the database). 
- **If the data is modified in the database it should be invalidated in the cache.** The process by which this happens is **cache invalidation**
- There are three main schemas for cache invalidation:
  - **Write-through cache** - data is written into the cache and the database at the same time. 
	- This schema is beneficial because it ensures that data will always be backed up to the servers in case of system failure.
	- The downside of this schema is that it can result in higher latency for write operations because each write must happen twice (in both the cache and the database)
  - **Write-around cache** - data is written directly to permanent storage, bypassing the cache.
	- This reduces cache write operations, reducing the chances of the cache being flooded with write requests.
	- The downside in that a read request for recently written data will result in a "cache miss" and must be read from slower back-end storage, and will thus have higher latency.
  - **Write-back cache** - data is written to cache alone and completion is immediately confirmed to the client. The write to permanent storage is done after a specified interval or once certain conditions have been met.
	- This results in low latency and high throughput for write-intensive applications.
	- However there is a major downside with an increased risk of data loss if the cache were to fail before the data can be backed up to the database.
### Cache eviction policies
There are many possible eviction policies but here are some of the most common choices:
- **First In First Out (FIFO)**: The cache evicts the first block accessed first without any regard to how often or how many times it was accessed.
- **Last In First Out (LIFO)**: The cache evicts the most recently accessed block first without any regard to how often or how many times it was accessed.
- **Least Recently Used (LRU)**: The cache discards the least recently used items first.
- **Most Recently Used (MRU)**: The cache discards the most recently used items first.
- **Least Frequently Used (LFU)**: The cache counts how often an item is needed. Those that are least often used are discarded first.
- **Random Replacement (RR)**: The cache randomly selects a candidate and discards it.

## Data Partitioning
- **Data partitioning** is a technique to break up a big database into many smaller components. 
- This functions through splitting up a DB/table across multiple machines in order to improve the manageability, performance, availability, and load balancing of an application.
- The justification is that after a certain scale point, it is simply much cheaper to scale horizontally vs. vertically.
### Partitioning Methods
There are many different ways to break up a database into smaller databases. Here are some of the most popular schemes:
- **Horizontal partitioning** - In this scheme different rows go into different tables. For example if you were to have a table that stored locations, using this scheme you could store ZIP codes less than 10000 and greater than 10000 in separate tables. Horizontal partitioning is also known as **Data Sharding**
  - The biggest problem with this approach is if the value whose range is used for partitioning isn't chosen carefully, then the partitioning schema will lead to unbalanced servers.
- **Vertical partitioning** - In this scheme we divide the data using a specific feature in their own server. For example, if we are building an Instagram like application - where we need to store data related to users, photos they upload, and people they follow - we can decide to place user profile information on one DB server, their friend list on another, and photos on a third server. Vertical partitioning is simple and typically has a low impact on the application.
  - The biggest drawback is that if our application experiences additional growth, then it may become necessary to further partition a feature specific DB across various servers (e.g., it would not be feasible for a single server to handle all photo requests for all users).
- **Directory Based Partitioning** - In this scheme a lookup service is created which is aware of the current partitioning schema and abstracts it away from the DB access code. Thus, in order to find out where a particular data entity resides, we query the directory server that holds the mapping between each tuple key to its DB server. This approach means we can perform tasks like anding servers to the DB pool or change our partition scheme without having an impact on the application.
### Partitioning Criteria
- **Key or Hash-based partitioning** - In this scheme, we apply a hash function to some key attributes of the entity we are storing; that yields the partition number. For example, if we have 100 DB servers and our ID is a numeric value that gets incremented by one each time a new record is inserted. This approach should ensure a uniform allocation of data among servers.
  - A drawback of this method is that adding new servers means changing the hash function, which would require redistribution of data and downtime. A workaround to this is Consistent Hashing.
- **List partitioning** - In this scheme, each partition is assigned a list of values, whenever we want to add a new record, we will see which partition contains our key and then store it there. For example, you can decide that all users living in Iceland, Norway, Sweden, Finland, or Denmark will be stored in a partition for Nordic countries.
- **Round-robin partitioning** - This scheme is very simple. With `n` partitions, the `i` tuple is assigned to partition `(i mod n)`.
- **Composite partitioning** - In this scheme, we combine any of the above partitioning schemes to devise a new scheme. Consistent hashing could be considered a composite of hash and list partitioning where the hash reduces the key space to a size that cane be listed.
### Common Problems
There are multiple constraints on the different operations that can be preformed. These tend to be due to the fact that operations across multiple tables or multiple rows in the same table will no longer run on the same server.
- **Joins and Denormalization** - Performing joins on a database which is running on one server is easy, but once a database is partitioned it can often no longer be feasible to perform such joins. Joins that span database partitions will not be performance efficient since data has to be compiled from multiple servers.
  - A common workaround is to denormalize the database so that queries that previously required joins can be performed from a single table
- **Referential integrity** - Just like how performing a cross-partition query on a partitioned database is not feasible, trying to enforce data integrity constrains (such as foreign keys) in a partitioned database can be made much more difficult. Most RDBMS do not support foreign key constrains across databases on different servers.
  - This means that applications that require referential integrity on a partitioned database often have to enforce it in the application code.
  - It is often the case that in partitioned databases, the applications have to run regular SQL jobs to clean up dangling references.
- **Rebalancing** 
  - There are many reasons why the partitioning may have to be changed over time:
	- The data distribution is not uniform
	- There is a lot of load on a partition
  - In such cases we need to create more DB partitions or rebalance existing partitions
  - Rebalancing partitions means the partitioning scheme is changed and all existing data is moved to new locations. Doing this is a massive task that requires server downtime.
	

