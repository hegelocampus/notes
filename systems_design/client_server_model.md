# Client Server Model
- This is the foundation of the modern Internet.
## What happens when you go to `google.com`?
- Client and Server
  - Client
	- This is something that sends data to a server.
	- Typically the browser.
	- It doesn't actually know what the server represents. At first it doesn't even know how to contact the server.
  - Server
	- Something that listens for clients and then returns data.
	- Typically listens for requests on a particular set of ports. That port must be specified in the client's request.
- DNS - Domain Name System:
  - Describes the entities and protocols involved in the translation from domain names to IP Addresses. Typically, machines make a DNS query to a well known entity which is responsible for returning the IP address of the requested domain name in the response.
- IP Address:
  - `127.0.0.1` is always your own local machine. It is aliased as `localhost`.
  - `192.168.x.y` is your private network. It contains your machine and all machines on your private network.
Steps:
- Client requests IP address of the server through a DNS query.
  - This responds with the IP address (the IP address is a unique identifier for the machine).
  - The IP address is typically registered with a particular host.
- Now that the client has the IP address they can send an `HTTP` request straight to the server.
  - The request is packed into packets and then sent over, through these packets to the server.
  - The request contains a source IP address, to which the server will respond with its own packaged response.
- The server will then send back the calculated response as its own package.
