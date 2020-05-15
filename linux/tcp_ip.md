# TCP/IP Networking
- **TCP/IP (Transmission Control Protocol/Internet Protocol)** is the networking system that underlies the Internet. TCP/IP does not depend on any particular hardware or operating system, so devices that speak TCP/IP can all exchange data despite their many differences.
- TCP/IP works on networks of any size or topology, even when they are not connected to the outside world.

## TCP/IP and its relationship to the Internet
### Network Standards and documentation
- The technical activities of the Internet community are summarized in documents known as Requests for Comments or RFCs.
  - These are comprised of Protocol standards, proposed changes, and informational bulletins.
  - These start as Internet Drafts and then either die or are promoted to the RFC series.
  - These are numbered sequentially, but also come with descriptive sub-titles but are formally cited by their number.
  - Once distributed the contents of an RFC are never changed.

## Networking Basics
- **TCP/IP** is a protocol "suite," meaning a set of network protocols designed to work smoothly together. It includes several components, each defined by a standards-track RFC or a series of RFCs:
  - **IP - Internet Protocol** - routes data packets from one machine to another (RFC791).
  - **ICMP - Internet Control Message Protocol** - defines several kinds of low-level support for IP, including error messages, routing assistance, and debugging help (RFC792).
  - **ARP - Address Resolution Protocol** - translates IP addresses to hardware addresses (RFC826).
  - **UDP  - User Datagram Protocol** - implements unverified, one way data delivery (RFC768).
  - **TCP  - Transmission Control Protocol** - implements reliable, full duplex, flow-controlled, error-corrected conversations (RFC793).
- These protocols are arranged in a hierarchy or "stack," with the higher-level protocols making use of the protocols beneath them. TCP/IP is conventionally described as a five-layer system, but the actual TCP/IP protocols inhabit only three of these layers.
- There is a good TCP/IP layering model diagram on **page 379**, I tried to re-create it but it wasn't legible
- We are technically out of IPv4 address space. But everything is still OK because of the following technologies:
  - **Network Address Translation (NAT)** - Allows entire networks of machines to hide behind a single IPv4 address.
  - **Classless Inter-Domain Routing (CIDR)** - Flexibly subdivides networks and promotes efficient back-bone routing
- Contention of IPv4 address is still an issue, but this tends to be reallocated in economic rather than technological ways nowadays.
- The underlying issue limiting IPv6's adoption is that IPv4 support is still mandatory for a device to be a functional citizen of the Internet (as of 2017).

### Packets and encapsulation

