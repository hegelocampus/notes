# System Design Interviews: A step by step guide
- System design interviews (SDIs) are tricky for three major reasons:
  - SDIs are very unstructured, the candidates are asked to work on an open-ended design problem that doesn't have a clear answer.
  - Candidates often lack experience in developing complex and large scale systems.
  - Candidates often neglect preparing for SDIs
- A step by step approach will help you break down SDIs

## Step 1: Requirements clarifications
- Because the prompts are often vague, you will need to ask questions about the exact scope of the problem we are solving.
- Because design questions don't have one correct answer, its important to clarify ambiguities early in the interview.
- You will have a much better chance of succeeding if you have first defined clear end goals of the system. Also since you only have 35-40 minutes to design a large system, you should clarify what parts you need to focus on.
- Here are some example questions that should be answered for designing a Twitter-like service:
  - Will users of our service be able to post tweets and follow other people?
  - Should we also design to create and display the user's timeline?
  - Will tweets contain photos and videos?
  - Are we focusing on the backend only or are we developing the front-end too?
  - Will users be able to search tweets?
  - Do we need to display hot trending topics?
  - Will there be any push notification for new (or important) tweets?

## Step 2: Back-of-the-envelope estimation
- It's always a good idea to estimate the scale of the system we're going to design. This will also help later when we will be focusing on scaling, partitioning, load balancing and caching.
- Here are some questions that should be answered in this section:
  - What scale is expected from the system (e.g., number of new tweets, number of tweet views, number of timeline generations per sec.)?
  - How much storage will we need? We will have different storage requirements if users can have photos and videos in their tweets.
  - What network bandwidth usage are we expecting? This will be crucial in deciding how we will manage traffic and balance load between servers.

## Step 3: System interface definition
- Define what APIs are expected from the system.
- This will not only establish the exact contract expected from the system but will also ensure we haven't gotten any requirements wrong.
Some examples of APIs for a Twitter-like service:
```
postTweet(user_id, tweet_data, tweet_location, user_location, timestamp, ...)
```
```
generateTimeline(user_id, current_time, user_location, ...)
```
```
markTweetFavorite(user_id, tweet_id, timestamp, ...)
```

## Step 4: Defining data model
- This will clarify how data will flow between different components of the system.
- This will be used later to guide data partitioning and management.
- You should be able to identify various entities of the system, how they will interact with each other, and different aspects of data management like storage, transportation, encryption, etc.
- Here are some entries for our Twitter-like service:
  - `User`: `UserId`, `Name`, `Email`, `DoB`, `CreationData`, `LastLogin`, etc.
  - `Tweet`: `TweetId`, `Concent`, `TweetLocation`, `NumberOfLikes`, `TimeStamp`, etc.
  - `UserFollow`: `UserId1`, `UserId2`
  - `FavoriteTweet`: `UserId`, `TweetId`, `Timestamp`
- During this section you should clarify
  - The database system you should use. SQL or NoSQL?
  - What kind of block storage should be used for photos and videos?

## Step 5: High-level design
- Draw a block diagram with 5-6 boxes representing the core components of our system. **You should identify enough components that are needed to actually solve the problem from end to end.**
- For Twitter, at a high-level, we will need multiple application servers to serve all the read/write requests with load balancers in front of them for traffic distribution. If we're assuming we will have a lot more read traffic (as compared to write), we can decide to have separate servers for handling these requests. On the backend, we need an efficient database that can store all the tweets and can support a huge number of reads. We will also need a distributed file storage system for storing photos and videos.
```
										    /-> Databases
Clients -> Load Balancer -> Server array <-<
										    \-> File Storage
```

## Step 6: Detailed design
- Dig deeper into two or three core components; you should use the interviewer's feedback to guide what parts of the system need further discussion.
- You should be able to present different approaches, their pros and cons, and explain why we prefer one approach over another. Remember there is no single answer; the only important thing to consider is the tradeoffs between different options while keeping system constraints in mind.
- Questions that should be answered in this phase for the Twitter-like example:
  - Since we will be storing a massive amount of data, how should we partition our data to distribute it to multiple databases? Should we try to store all the data of a user on the same database? What issue could that cause?
  - How will we handle "hot" users who tweet a lot or follow a lot of people?
  - Since users' timeline will contain the most recent (and relevant) tweets, should we try to store our data in such a way that is optimized for scanning the latest tweets?
  - To what degree and at which layer should we introduce a cache to speed things up?
  - What components need better load balancing?

## Step 7: Identifying and resolving bottlenecks
- Try to discuss as many bottlenecks as possible and different approaches to mitigate them
- For the Twitter-like example:
  - Is there any single point of failure in our system? What are we doing to mitigate it?
  - Do we have enough replicas of the data so that if we lose a few servers, we can still server our users?
  - Do we have enough copies of different services running such that a few failures will not cause total system shutdown?
  - How are we monitoring the performance of our service? Do we get alerts whenever critical components fail or their performance degrades? **Try to use a data driven analysis to sell this here**, for example you can say that it will be important to set up monitoring in order to analyze what parts of the system are performing well and what parts could use further optimization.
