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

