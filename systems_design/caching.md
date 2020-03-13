# Caching
- Possibly one of the most important systems design concepts.
- You can use caching to speed up the operation speed of your system. This tends to be used for especially complex operations.
- Caching, in short, is storing data in a location that is different for the origin of data.
- Caching can happen at any level of the system, from the server to the client. You can even have a cache in between levels in the system.
## In the context of systems design
- Really helpful in speeding up the system in these instances:
  - When doing a lot of network requests that you'd like to avoid doing.
  - When doing a very computational operation, perhaps one with poor time complexity.
- Also really useful for reducing database load.
  - If each client is hitting the database with the same request, it may make sense to cache the response to avoid overloading the database.
- Client side caching: You can cache static content on the client device if you know the content will always be the same or is otherwise not often changed.
## Types of caches
- The danger with caching is that you now have two sources of truth for the web-content, the cache and the server. 
- Write-through caches:
  - When you write data you write data to the cache and the database at the same time.
  - The server overwrites the cache with each write and also saves the data to the database.
  - The downside is that you still have to go to the database with each write operation.
- Write-back caches:
  - Server only updates cache. So the cache is now more up to date than your database.
  - The server asynchronously updates the database on a set schedule.
  - The downside of this type of cache is if the server running the cache ever fails then the cached data will be lost, which is very bad. But there are ways to reduce this risk.
## Caches in the real world
- Caches can become stale if there is more recent data that they do not have access to. This is more important for some features vs. others, for example on YouTube it is far less imperative for view count to be up to date than comments.
- As a rule of thumb definitely consider caching if:
  - Your data is immutable
  - you only have a single thing reading or writing your data
  - you don't care about consistency
  - you don't care about stale data or your system is set up to minimize this
## Eviction policies
- This is how you get rid of stale data
- There are a few popular policies:
  - LRU - Get rid of the least **recently** used data.
  - LFU - Get rid of the least **frequently** used data.
  - FIFO - Get rid of the oldest data first

