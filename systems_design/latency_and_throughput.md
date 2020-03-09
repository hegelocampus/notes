# Latency and Throughput
- The two most important measures of the performance of a system.
## Latency
- How long it takes for data to traverse a system.
  - Specifically how log it takes data go get from one specific point to another specific point in a system. For instance the time it takes for a piece of data to get from the server to the client.
- Different things in the system have different latencies. Here are some standard latencies:
  - Reading 1mb from RAM - 250 microseconds - very fast
  - Reading 1mb from SSD - 1000 microseconds - fast
  - Sending 1mb over network - 10,000 microseconds - moderately fast
  - Reading 1mb from an HDD - 20,000 microseconds - kinda slow
  - Sending a packet from California to the Netherlands and then back to California - 150,000 microseconds - very slow - This is because electricity takes time to physically travel
- When designing systems you typically want to optimize by lowering the overall latency. This is more important in some systems vs in others, for instance video games _really_ need to have very low latency, a website on the other hand may value accuracy over latency.
## Throughput
- How much work a machine can perform in given amount of time. Normally in system design questions this is specifically how much data can be transfered from one point in the system to another point in a given amount of time.
- The throughput is in practice, the number of requests a given server can handle simultaneously.
  - Can be measured in requests per second (RPS or QPS).
- This is typically optimized through simply paying for more server processing speed. 
  - But just increasing throughput isn't guaranteed to fix a specific problem on its own.
  - It may be beneficial to actually increase the number of servers.
## Together
- These are not necessarily correlated. You can have high latency without having high throughput and vice-versa.
