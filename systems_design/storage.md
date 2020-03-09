# Storage
- A database is a thing that allows you to store and retrieve data
  - Its two main functions are to **record** and **query** data.
  - It is not a magic opaque box that exists somewhere in the ether
  - It is almost always just a server
- There is a common assumption that if you store data in a database the data will persist through outages or other issues. **This isn't always correct.**
- Storage is very very complex
  - Google Cloud Platform alone offers 8 different storage options
- The database going down is essentially equivalent to the whole system going down
- Distributed systems - data stored across multiple machines. There are multiple strategies to do this.
## Database CS fundamentals
- Disk
  - Kinda slow.
  - Data persists
- Memory
  - Very fast
  - Data not persistent

