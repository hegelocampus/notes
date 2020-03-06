# Network Protocols
- Protocol:
  - An agreed upon standard for performing a particular action.
- Networking Protocol:
  - Standard for communicating between machines over a network.
  - This defines:
	- The kinds of messages.
	- The format of the messages.
	- The order of the messages, if they have an order.
	- Whether or not the messages should have a response, and what that response should look like.
- You really don't need to know about the majority of network protocols.
## IP, TCP, and HTTP
- These are the most important protocols.
### IP:
- Internet Protocol
- This essentially defines the way the Internet works
#### IP Packets
- These are the building blocks of the way machines communicate.
- Made up of bytes
- Limited in size, maximum of 2^16 bytes. Because of this you often need to send multiple packets to transmit all the needed data. But the IP protocol doesn't verify that packets have been received or the order that the packages should be read in.
- Two main sections:
  - IP Header: 
	- Contains useful information about the packet. Namely the source IP, the destination IP address, the IP version **if you have a singe IP Packet you both know where the message is going and where it came from**
	- Very small, between 20 and 60 bytes
  - IP Data/Payload:
	- The actual information specifying the messages data
### TCP:
- Aims to solve the shortcomings of the IP protocol, namely to ensure packets have been successfully received, that the packets are placed in the correct order, and that the packs are not corrupted.
- This type of request adds a TCP header to a normal IP packet.
  - This header specifies a "handshake" protocol where there is a connection established between the server and the client where data can be openly transmitted.
	- This is somewhat limited. If data is not sent quickly enough the connection can time out. And either of the machines can also end the connection.
### HTTP - Hypertext Transfer Protocol
- Built on top of TCP. 
- Adds the abstraction of the **request-response paradigm**. One machine sends a request to another machine, this request demands a response.
- Requests have a lot of properties that are defined by the HTTP protocol. Here are some of the properties:
  - Host & port - the destination server of the request
  - Method - one of a preset group of possible methods. Define the purpose of the request. I.e., `GET`, `PUT`, `DELETE`, etc.
	- Its important to note that these requests don't necessarily have to perform the task intended by the protocol, what actually happens is up to the developer (although it really should do the typical thing or you will make everyone angry and confused).
  - Path - the route on the server, following the host name. This is used server side to make-sense-of/route the request.
  - Headers - collection of key value pairs that contain important information about the request.
	- `content-type` - The format that the response data (the body) should be formatted in.
	- `content-length` - The length of the body.
  - Body - The data that is being sent to the server.
- Responses:
  - Status code - The type of the response, there are a lot of these and they all mean a specific thing, you should follow the guidelines.
	- 404 - Not found
	- 401 - Unauthorized

