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
- It takes two (or more) communicating entities running the same protocol to successfully accomplish a task.
- All activity in the Internet that involves two or more communicating remote entities is governed by a protocol.
***A protocol*** _defines the format and order of messages exchanged between two or more communicating entities, as well as the actions taken on the transmission and/or receipt of a message or other event._
## The network edge
- This is comprised of the end systems, which can be desktop computers, servers, and mobile devices. These are also referred to as _hosts_, because the host the applications.
- Hosts themselves are divided into two categories: **clients** and **servers**
  - Clients tend to be desktop and mobile PCs
  - Servers tend to be more powerful machines that store and distribute Web pages, stream video, relay e-mail, and so on. Today most of these reside in large **data centers**.
### Access Networks
- **Access network**: The network that physically connects an end system to the first router (also known as the "edge router") on a path from the end system to any other distant end system.
- **DSL**:
  - Internet access is granted using the existing phone line.
  - Different types of data are encoded at different frequencies:
	- A high-speed downstream channel, in the 50kHz to 1MHz band
	- A medium-speed upstream channel, in the 4kHz to 50kHz band
	- A two-way telephone channel, in the 0 to 4kHz band
  - Through transmitting the data at different frequencies the link behaves almost as if there were three separate links.
- **Cable Internet access**:
  - Makes use of the cable television company's existing cable television infrastructure.
  - Fiber optics connect the cable head end to neighborhood-level junctions, from which traditional coaxial cable is then used to reach individual residences.
  - Often referred to as hybrid fiber coax (HFC) because both fiber and coaxial cable are used.
  - The signal is received in a residence by a **modem** which transforms the analog signal sent from the cable modems back into digital format. These modems divide the HFC network into two channels, a downstream and an upstream channel.
  - One important characteristic is that it is a shared broadcast medium. Every packet sent by the head end travels downstream on every link to every home and every packet sent by a home travels on the upstream channel to the head end.
  - Because the upstream channel is shared, a distributed multiple access protocol is needed to avoid collisions.
- **Fiber to home (FTTH)**:
  - Provides an optical fiber path from the CO directly to the home.
  - There are several competing technologies for optical distribution from the CO to the homes.
	- The simplest is called direct fiber. This is where one fiber leaves each home.
	- It is more common for each fiber leaving the central distributer to be shared by many homes, with the signal is not split until the fiber gets relatively close to its destination. There are two main ways that this is achieved: active optical networks (AONs) and passive optical networks (PONs). AON is essentially switched Ethernet.
- In areas where the above types of access networks are not available for whatever reason there are also **satellite links** and **dial-up** available, although these both have heavy limitations (slow speed and poor reliability).
#### Ethernet and WiFi
- A **local area network (LAN)** is often used to connect an end system to the edge router.
- **Ethernet** is the most prevalent access technology for a LAN network.
  - Ethernet users use twisted-pair copper wire to connect to an Ethernet switch. The switch, or network of switches is then connected into the larger Internet network.
- **Wireless LAN**, through WiFi, is also incredibly common
  - In this setup users transmit/receive packets to/from an access point that is connected into the residence/enterprise's network, which in turn is connected to the wired Internet.
### Physical Media
- The **physical medium** is what sits between the transmitter-receiver pair
  - Some examples are twisted-pair copper wire, coaxial cable, multimode fiber-optic cable, terrestrial radio spectrum, and satellite radio spectrum.
- Physical media fit into two major categories of **guided media** and **unguided media**
  - Guided media: The waves are guided along a solid medium, e.g., fiber-optic cable, a twisted-pair copper wire
  - Unguided media: The waves propagate in the atmosphere and in outer space, e.g., wireless LAN, a digital satellite channel
##### Twisted-Pair Copper Wire
- An **Unshielded twisted pair (UTP)** is commonly used for computer networks within a building. The rates for this medium range from 10 Mbps to 10Gbps (likely out of date)
- Data rates depend on the thickness of the wire and the length of the wire
##### Coaxial Cable
- Similar to twisted pair, coaxial cable consists of two copper conductors, but  in this configuration the two conductors are concentric rather than parallel.
- Achieves high data transmission rates.
- Common in cable television systems.
- Often used as a guided **shared medium**. Meaning a number of end systems can be connected directly to the cable, with each of the end systems receiving whatever is sent by the other end systems.
##### Fiber Optics
- A thin, flexible medium that conducts pulses of light, with each pulse representing a bit.
- Can support tremendous bit rates
- Immune to electromagnetic interference
- Have very low signal attenuation up to 100 kilometers
- Very hard to tap
- The preferred  long-haul guided transmission media, particularly for overseas links
- The optical devices, such as transmitters, receivers, and switches, that are needed to use fiber optic media are very expensive, hindering the adoption of fiber optics.
##### Terrestrial Radio Channels
- Carry signals in the electromagnetic spectrum
- Require no physical wire to be installed
