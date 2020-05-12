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
