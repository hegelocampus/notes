# Overview
- How is a network signal translated into something that a computer can understand?
- How does packet loss happen? Where do those packets go?
- Could a packet get stuck in transit?
- What do the Application, Transport, Network, Link, and Physical layers do?
- What kind of attacks happen on networks? How can we protect against these attacks?
## The Internet
- What _is_ the Internet? It can be broken down in two main ways:
  - Nuts-and-Bolts: The basic hardware and software components that make up the Internet.
  - A networking infrastructure that provides services to distributed applications.
### Nuts-and-Bolts Description
- All devices are called **hosts** or **end systems**
- End systems are connected together by a network of **communication links** and **packet switches**.
  - Different links can transmit data at different rates, this **transmission rate** is measured in bits/second.
- When sending data the sending system constructs **packets** through segmenting the data and adding header bytes to each segment.
  - These packets are then sent through the network to the destination end system, where they are reassembled into the original data.
- Packet switch:
  - Takes a packet arriving on one of its incoming communication links and forwards that packet to one of its outgoing communication links.
  - These come in many shapes, the two main types are **routers** and **link-layer switches**. Both of these forward packets towards their ultimate destinations.
	- Link-layer switches are typically used in access networks.
	- Routers are typically used in the network core.
  - The sequence of communication links and packet switches traversed by a packet from the sending end system to the receiving end system is know as a **route** or **path** through the network.
- End systems access the Internet through **Internet Service Providers (ISPs)**, including residential ISPs such as local cable or telephone companies; corporate ISPs; university ISPs; ISPs that provide WiFi access in airports, hotels, coffee shops, and other public places; and cellular data ISPs, providing mobile access to our smartphones and other devices.
  - Each ISP is in itself a network of packet switches and communication links.
  - ISPs provide a variety of types of network access to the end systems, including residential broadband access such as cable modem or DSL, high-speed local area network access, and mobile wireless access.
  - The Internet is all about connecting end systems to each other, so ISPs themselves must be interconnected. Lower-tier ISPs are interconnected through national and international **upper-tier ISPs** such as Level 3 Communications, AT&T, Sprint, and NTT.
	- An upper-tier ISP consists of high-speed routers interconnected with high-speed fiber-optic links.
  - Each ISP network, both upper and lower-tier, is managed independently, runs the IP protocol, and conforms to certain naming and address conventions.
- End systems, packet switches, and other pieces of the Internet run **protocols** that control the sending and receiving of information within the Internet.
  - The **Transmission Control Protocol (TCP)** and the **Internet Protocol (IP)** are two of the most important protocols in the Internet.
	- These are collectively known as **TCP/IP**
- The protocols that are used in the Internet are defined by the **Internet standards**, which themselves are developed by the Internet Engineering Task Force (IETF)
  - Their standards documents are called **requests for comments (RFCs)**. These started out as general requests for comments to resolve network and protocol design problems that faced the precursor to the Internet. These define protocols such as TCP, IP HTTP, and SMTP.
  - There are also other standards groups for different parts of the network, for instance for the link layer there is the IEEE 802 LAN/MAN Standards Committee, which specifies the Ethernet and WiFi standards.
### Services Description
- This description relies on understanding the Internet as _an infrastructure that provides services to applications_.
- The applications are said to be **distributed applications** since they involve multiple end systems that exchange data with each other. Importantly, Internet applications run on end systems. Although packet switches facilitate the movement of data among end systems, they themselves are not concerned with the application that is the source or sink of data.
- End systems attached to the Internet provide a **socket interface** that specifies how a program running on one system asks the Internet infrastructure to deliver data a specific destination program running on another end system.
  - The socket interface is a set of rules that the sending program must follow so that the Internet can deliver the data to the destination program.
### What is a Protocol?
