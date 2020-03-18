# Load Balancers
- Extremely important. You will likely use them in every system design interview ever.
- The more requests a single server gets the more likely it is to get overloaded and fail. There are multiple ways to handle this:
  - You could vertically scale the system by simply adding more processing prower to the existing server.
  - You could horizontally scale the server by increasing the number of servers that you are using. Doing this requires that your clients be router to the proper server. This is done by the load balancer.
- Load Balancer 
  - Is typically a server that sits in between the clients and the servers
  - Handles deciding which server to redirect the particular request to.
  - Not only prevents a resource from being overloaded, but it also increases system throughput and typically improves latency as well.
  - Can typically be understood as a type of reverse proxy.
  - If you have multiple IPs registered in your DNS server the DNS server will return the IPs in a load balanced way
  - There are both software and hardware load balancers. Software load balancers are typically much more flexible.
## How load balancers actually work
- How does it even know that there are multiple servers to redirect traffic to?
  - The new servers are typically registered with the load balancer when they are created
- How does the load balancer choose which server to send a request to? Multiple options:
  - Purely random: not super effective.
  - Round-robin: each request is sent to the next server in a list, this is like a queue.
  - Weighted round-robin: some servers are chosen to take on more requests than the other servers. This is typically done when you have servers with different processing power.
  - Based on performance or load of the servers: In this case the load balancer preforms health-checks on the individual servers and then chooses where to send a request based on how the servers are doing.
  - IP based selection: The IP address of the client is hashed and the traffic is directed to the server with a matching hash.
  - Distribute requests based on requests: For example requests related to payments could all be routed to a particular server or set of servers and all other requests to be routed to a different server or set of servers.
- Server selection should be decided based on the use case. It may make sense to use multiple load balancers that use different load balancing strategies.
  - For example it may make sense to have a load balancer that redirects to a different load balancer based on IP, with that load balancer then using a different load balancing technique.

