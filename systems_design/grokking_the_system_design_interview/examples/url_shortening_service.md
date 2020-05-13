# Designing a URL Shortening service like TinyURL
- This service will provide short aliases redirecting to long URLs
- Difficulty level: Easy
## 1. Why do we need URL shortening?
- URL shortening is used to create shorter aliases for long URLs. These shortened aliases are often called "short links."
- Users are redirected to the original URL when they hit these short links.
- Save a lot of space when displayed, printed, messaged, or tweeted.
- Users are less likely to mistype shorter URLs
- Used for optimizing links across devices, tracking individual links to analyze audience and campaign performance, and hiding affiliated original URLs

## 2. Requirements and Goals of the System
- **Always clarify requirements at the beginning of the interview.**
- Our URL shortening system should meet the following requirements:
  - **Functional Requirements:**
	- Given a URL, our service should generate a shorted and unique alias of it. This link should be short enough to be easily copied and pasted into applications.
	- When users access a short link, our service should redirect them to the original link.
	- Users should optionally be able to pick a custom short link for their URL.
	- Links will expire after a standard default timespan. Users should be able to specify the expiration time.
  - **Non-Functional Requirements:**
	- The system should be highly available. This is required because if our service is down, all the URL redirections will start failing.
	- URL redirection should happen in real-time with minimal latency.
	- Shortened links should not be guessable (non predictable)
  - **Extended Requirements:**
	- Analytics; e.g., how many times a redirection happened?
	- Our service should be accessible through REST APIs by other services.

## 3. Capacity Estimation and Constraints
- Our system will be read-heavy. There will be lots of redirection requests compared to new URL shortenings. Let's assume a 100:1 ration between read and write.
- **Traffic estimates:** 
  - Assuming we will have 500M new URL shortenings per month, with 100:1 read/write ration, we can expect 50B redirections during the same period:
    - 100 * 500M => 50B
  - What would the Queries Per Second (QPS) be for our system?
	- 500 million / (30 days * 24 hours * 3600 seconds) => ~200 URLs/s
  - Considering 100:1 read/write ratio, URL redirections per second will be:
	- 100 * 200 URLs/s = 20K/s
- **Storage estimates:**
  - Let's assume we store every URL shortening request (and associated shortened link) for 5 years. Since we have 500M new URLs every month, the total number of objects we expect to store will be 30 billion:
	- 500 million * 5 years * 12 months = 30 billion
  - Let's assume that each stored object will be approximately 500 bytes (just a ballpark estimate). So we will need 15TB of total storage:
	- 30 billion * 500 bytes = 15 TB
- **Bandwidth estimates:**
  - For write requests, since we expect 200 new URLs every second, total incoming data for our service will be 100KB per second
	- 200 * 500 bytes = 100 KB/s
  - For read requests, since every second we expect ~20K URL redirections, total outgoing data for our service would be 10MB per second:
	- 20K * 500 bytes = ~10 MB/s
- **Memory estimates:**
  - If we want to cache some of the hot URLs that are frequently accessed, how much memory will we need to store them? The 80-20 rule is a useful rule to use here, meaning 20% of URLs will generate 80% of traffic, so caching the 20% most used URLs will offer substantial performance benefits.
  - Since we have 20K requests per second, we will be getting 1.7 billion requests per day:
	- 20K requests * 3600 seconds * 24 hours = ~1.7 billion requests
  - To cache 20% of these requests 170GB of memory will be required:
	- 0.2 * 1.7 billion * 500 bytes = ~170GB
  - One thing to note here is that since there will be a lot of duplicate requests, our actual memory usage will be less than 170GB
- **High Level estimates:** Assuming 500 million new URLs per month and 100:1 read:write ratio, following is the summary of the high level estimates for our service:
  - **New URLs:** 200/s
  - **URL redirections:** 20K/s
  - **Incoming data:** 100KB/s
  - **Outgoing data:** 10MB/s
  - **Storage for 5 years:** 15TB
  - **Memory for cache:** 170GB

## 4. System APIs
- **This section should explicitly state what is expected from the system**
- Here are a set of possible definitions for the APIs for creating and deleting URLs:
```
createURL(api_dev_key, original_url, custom_alias=None, user_name=None, expire_date=None)
```
- **Parameters:**
  - `api_dev_key` (string): The API developer key of a registered account. One of the uses for this will be to throttle users based on their allocated quota.
  - `original_url` (string): Original URL to be shortened.
  - `custom_alias` (string): Optional custom key for the URL.
  - `user_name` (string): Optional user name to be used in the encoding.
  - `expire_date` (string): Optional expiration date for the shortened URL.
- **Returns:** (string)
  - A successful insertion returns the shortened URL; otherwise it returns an error code.
```
deleteURL(api_dev_key, url_key)
```
- **Parameters:**
  - `url_key` (string): The shortened URL to be deleted.
- **Returns:** (string)
  - A successful deletion returns a success code and "URL Removed"
- **How do we detect and prevent abuse?**
  - A malicious user can put us out of business by consuming all URL keys in the current design.
  - To prevent abuse, we should limit users via their `api_dev_key`. Where each `api_dev_key` can be limited to a certain number of URL creations and redirections within some predetermined time period.
  - This limit can potential be adjusted on a user by user basis.

## 5. Database Design
- A few observations about the data we will store:
  - We need to store billions of records
  - Each object we store is small (less than 1K)
  - There are no relationships between records - other than storing which user created a URL.
  - Our service is read-heavy

#### Database Schema:
- We need two tables: one for storing information about the URL mappings and one for the user's data ho created the short link.

##### URL
| PK  | `Hash: varchar(16)`         |
| --- |---------------------------|
|     | `OriginalURL: varchar(512)` |
|     | `CreationDate: datetime`    |
|     | `ExpirationDate: datetime`  |
|     | `UserID: int`               |

##### User
| PK  | `UserID: Int`               |
| --- |---------------------------|
|     | `Name: varchar(20)`         |
|     | `Email: varchar(32)`        |
|     | `CreationDate: datetime`    |
|     | `LastLogin: datetime`       |

### What kind of database should we use?
- Since we anticipate storing billions of rows and don't need complex relationships between objects, a NoSQL store like DynamoDB, Cassandra, or Riak will be the best choice. 
- A NoSQL choice will be much easier to scale and since we won't even need to run complex queries there are no real benefits to SQL.

## 6. Basic System Design and Algorithm
- The problem we are solving is how to generate a short and unique key for a given URL.

### a. Encoding actual URL
- One possible solution would be to compute a unique hash (e.g., MD5 or SHA256, etc.) of the given URL. The hash can then be encoded for displaying.
- A reasonable question would be what length should the short key of the URL be? 6, 8, or 10 characters?
  - Using base64 encoding, a 6 letter key would result in 64^6 = ~68.7 billion possible strings.
  - Using base64 encoding, a 8 letter key would result in 64^8 = ~281 trillion possible strings
  - With 68.7B unique strings, let's assume six letter keys would suffice for our system.
- If we use the MD5 algorithm as our hash function, it'll produce a 128-bit hash value. After base64 encoding, we'll get a string having more than 21 characters. Since we only have space for 8 characters, how will we choose our key? We can take the first 6 (or 8) letters for the key, but this could result in key duplication, to resolve that we can choose some other characters out of the encoding string or swap some characters.

#### Issues with this solution
- If multiple users enter the same URL, they can get the same shortened URL, which is not acceptable.
- What if parts of the URL are URL-encoded? For example http://www.educative.io/distributed.php?id=design, and http://www.educative.io/distributed.php%3Fid%3Ddesign are identical except for the URL encoding.

#### Workarounds for these issues
- We can append an increasing sequence number to each input URL to guarantee that they are unique (this is near equivalent to salting a password hash), and then generate a hash of it. We don't need to store this sequence of numbers in the databases though. A possible problem with this fix is now we have to deal with an ever-increasing sequence number. Can it overflow? Appending an increasing sequence number will also impact the performance of the service.
- Another solution could be to append user id (which should be unique) to the input URL. However, if the user has not signed in, we would have to ask the user to choose a uniqueness key (This came from the reading and I honestly don't understand the issue here. It seems that making users sign in before creating a URL is fine if your service is attempting to differentiate itself from other URL shortening services by providing URL tracking information). 

### b. Generating keys offline
- Another possible solution is to use a standalone **Key Generation Service (KGS)** that generates six-letter strings beforehand and stores them in a database (let's call it key-DB). Then whenever we want to shorted a URL, we will just take one of the pre-generated keys and use it.
- This approach will significantly simplify our solution and will make our service quite fast. Not only are we not encoding the URL, but we won't have to worry about duplications or collisions. KGS will make sure that all the keys inserted into key-DB are unique.

#### Could concurrency cause problems?
- As soon as a key is used, it should be marked in the database to ensure it doesn't get reused. If there are multiple servers reading keys concurrently, we might get a scenario where two or more servers try to read the same key from the database. How can we solve this concurrency problem?
- Servers can use KGS to read/mark keys in the database. KGS can use two tables to store keys: one for keys that are not used yet, and one for all the used keys. As soon as KGS gives keys to one of the servers, it can move them to the used keys table. KGS can always keep some keys in memory so that it can quickly provide them whenever a server needs them.
- For simplicity, as soon as KGS loads some keys in memory, it can move them to the used keys table, ensuring that each server gets unique keys. If KGS dies before assigning all the loaded keys to some sever, we will be wasting those keys-which could be acceptable, given the huge number of keys we have.
- KGS also has to make sure not to give the same key to multiple servers. For that, it must synchronize the data structure holding the keys before removing keys from it and giving them to a server.

#### What would be the key-DB size?
- With base64 encoding, we can generate 68.7B unique six letter keys. Given we need one byte to store one alpha-numeric character, we can store all these keys in: 6 (characters per key) * 68.7B (unique keys) = 412GB

#### Isn't KGS now a single point of failure?
- Yes. To solve this we can have a standby replica of KGS. So whenever the primary server dies, the standby server can take over to generate and provide keys.

#### Can each app server cache some keys from key-DB?
- Yes, that would greatly speed things up. The downside to doing this would be that if the application server dies before consuming all the keys we would end up losing those keys. But this may be acceptable given the number of keys.

#### How would we perform a key lookup?
- We can look up the key in our database to get the full URL. If it's present in the DB, issue an "HTTP 302 Redirect" status back to the browser, passing the stored URL in the "Location" field of the request. If that key is not present in our system, issue an "HTTP 404 Not Found" status or redirect the user back to the homepage.

#### Should we impose size limits on custom aliases?
- Our service supports custom aliases. Users can pick any "key" they like, but providing a custom alias is not mandatory. Although it is reasonable to impose a size limit on a custom alias to ensure we have a consistent URL database. Let's assume that users can specify a maximum of 16 characters per customer key.

## Data Partitioning and Replication
- To scale our DB, we will need to partition it so that it can store information about billions of URLs. 

#### a. Range Based Partitioning:
- We can store URLs in separate partitions based on the first letter of the hash key. Hence we save all the URLs starting with letter 'A' (and 'a') in one partition, save those that start with letter 'B' in another partition and so on. This approach is called range-based partitioning.
- We should come up with a static partitioning scheme so that we can always store/find a URL in a predictable manner.
- The main issue with this approach is that it can lead to unbalanced DB servers. For example, we decide to put all URLs starting with 'E' into a DB partition, but later we realize that we have too many URLs that start with the letter 'E'.

#### b. Hash-Based Partitioning
- In this scheme, we take a hash of the object we are storing, then calculate which partition to used based upon the hash. In our case, we can just take the hash of the 'key' or the short link to determine the partition in which we store the data object.
- This approach can still potentially lead to overloaded partitions, which can be solved through using **Consistent Hashing**.

## 8. Cache Implementation
- We can cache URLs that are frequently accessed. We can use some off-the-shelf solution like Memcached, which can store full URLs with their respective hashes. Through using a caching service here the application servers can quickly check if the cache has the desired URL before they attempt to ping the backend storage.

#### How much cache memory should we have?
- We can start with 20% of daily traffic, and based on the clients' usage pattern, adjust how many cache servers we need.
- As estimated above, we need 170GB of memory to cache 20% of daily traffic. Since a modern-day server can have 256GB of memory, we can easily fit all the cache into one machine. An alternative solution would be to use a couple of smaller servers to store all these hot URLs.

#### Which cache eviction policy would best fit our needs?
- When the cache is full, and we want to replace a link with a newer/hotter URL, how would we choose? 
- Least Recently Used (LRU) can be a reasonable policy for our system. 
  - Under this policy, we discard the least recently used URL first. We can use a Liked Hash Map or a similar data structure to store our URLs and Hashes, which will also be used to keep track the URLs that have been accessed recently.
- To further improve the efficiency of our system, we can replicate our caching servers to distribute the load between them.

#### How can each cache replica be updated?
- Whenever there is a cache miss, our servers would be hitting a backend database. Whenever this happens, we can update the cache and pass the new entry to all the cache replicas. Each replica can update its cache by adding the new entry. If a replica already has that entry, it can simply ignore it.

## 9. Load Balancer (LB)
- We can add a Load balancing layer at three places in our system:
  - Between Clients and Application servers.
  - Between Application Servers and database servers.
  - Between Application Servers and Cache servers.
- A decent initial solution would be to use a simple Round Robin approach that distributes incoming requests equally among backend servers. This LB is simple to implement and does not introduce any overhead. Another benefit of this approach is that if a server is dead, the LB will take it out of rotation and will stop sending any traffic to it.
- An issue with a Round Robin LB is that we don't take the server load into consideration. If a server is overloaded or slow, the LB will not stop sending new requests to that server. To handle this, a more intelligent LB solution can be used that periodically queries the backend server about its load and adjusts traffic based on that.

## 10. Purging or DB cleanup
- Should entries stick around forever or should they get purged? If a user-specified expiration time is reached, what should happen to the link?
- If we chose to actively search for expired links to remove them, it would put a lot of pressure on our database. Instead, we can slowly remove expired links and do a lazy cleanup. Our service will make sure that only expired links will be deleted, although some expired links can live longer but will never be returned to users.
  - Whenever a user tries to access an expired link, we can delete the link and return an error to the user.
  - A separate cleanup service can run periodically to remove expired links from our storage and cache. This service should be very lightweight and can be scheduled to run only when the user traffic is expected to be low.
  - We can have a default expiration time for each link (e.g., two years).
  - After removing an expired link, we can put the key back in the key-DB to be reused.
  - Should we remove links that haven't been visited in some length of time, say six months? This could be tricky. Since storage is cheap, we can decide to keep links forever if we wanted.

## 11. Telemetry
- How many times has a short URL has been used, and what were the user's locations, etc.? How would we store these statistics?
- If it is part of a DB row that gets updated on each view, what will happen when a popular URL is slammed with a large number of concurrent requests?
- Some statistics that are worth tracking:
  - Country of the visitor
  - Date and time of access
  - Web page that referred the click
  - Browser of the visitor
  - Platform from which the page was accessed

## 12. Security and Permissions
- Can users create private URLs or allow a particular set of users to access a URL?
- We can store the permission level (public/private) with each URL in the database.
- We can also create a separate table to store UserIDs that have permission to see a specific URL.
- If a user does not have permission and tries to access a URL we can send an error (HTTP 401) back.
- Given that we are storing our data in a NoSQL wide-column database like Cassandra, the key for the table storing permissions would be the 'Hash' (or the KGS generated 'key'). The columns will store the UserIDs of those users that have the permission to see the URL.

