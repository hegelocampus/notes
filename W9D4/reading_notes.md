# Rails Auth
## Authentication
### Strategies?
- There is no good way to do authentication trough URLS because `HTTP` is stateless 
- The only real solution is to use cookies
### Cookies
- The clients browser is actually what sets the rules for the cookies
- Cookies are sent up in the headers of the clients requests
- Although this doesn't solve the authentication problem by itself
  - This is because any client can change any of their cookies on their own
  - This basically means they can wreck total chaos
### Authentication
- The solution to the above is to send over a `session_token` that holds the users id, that we expect to be sent back whenever the user comes back, when the user logs out the `session_token` on the server end would get deleted
  - This `session_token` is only sent over after the server is given a correct username/password combo
### Encoding, encrypting
- **Encoding** is storing info that essentially just needs a pattern to translate it back and fourth from plain to encoded text
  - Base64 encoding is a very popular encoding method that uses a standardized ASCII table to encode text
	- This encoding method is used for pretty much everything
  - Encoding is weak because it is very easy to decode it if you know the system that translates the string into the encoded text
- **Encrypting**
  - Encrypted data requires a much more complicated translation method that allows for the data to be translated in a multitude of different ways
	- E.g., the Ceaser cipher can translate the string into an indeterminate number of possible results by simply changing the parameters that control how many characters are shifted
- If the server stores all the users passwords as plain text then those users are incredibly vulnerable because servers breaches aren't completely preventable
- We should defend user info (especially passwords) against the strongest possible attacker, such an attacker would have access to all server data
  - The solution isn't encrypting or encoding
- Even encryption is at risk of data breaches because your server must hold the decryption method in order to test if the user is valid, this means that it may be slightly harder to gain access to user passwords, but if someone has already breached into your database they probably have the means to steal your decryption method
### Hashing
- Hashing is the solution to the authentication problem
  - Hashing is a one way method, there is no way to get from the output of the hash function back to the original input
  - Hashing can be used to store passwords because hashing is uniform so the same input will always result in the same result
  - We can store the users `password_hash` without having to risk releasing the users password to the outside world
- One issue with hashing is **hash collisions**
  - Hash collisions are when **two unique inputs result in the exact same hash**
  - Hash collisions are unavoidable because math, we can make them exceedingly rare but it will always still be a possibility
- **Cryptographic hashing functions** are a special group of hashing functions that are extremely secure and have extremely low collision rate
  - Some examples:
	- SHA-1
	- MD5
	- SHA-2
	- Scrypt
	- Bcrypt (Blowfish)
  - Cryptographic hashes typically produce massive hashes
  - You should always use the most up to date hashing function because all hashing function eventually are cracked and become very weak
### Salting
- The biggest weakness of hashes is that ***USERS ARE STUPID*** 
  - Users reuse passwords so a users password is only as strong on the weakest sight they gave their password to
- **Rainbow tables** are collections off a huge percentage of the most common passwords that been run through all the most common cryptographic hashing functions
  - Because the majority of users use a most popular passwords all you need to breach the data of most of your users is a rainbow table
- The solution to dumb users is **Salting**
  - Salt is a random bit of information that gets added to the users password before it is hashed this will cause the hash to be different than what is on the rainbow table
  - The server needs to then store the hash along side the users info so that we can always add the same salt to the users inputted password to check it against the hashed value
- Salt makes it incredibly hard for an attacker to get the users data, and **with randomly generated salt, all users will have unique data in the table so there will not be a large chunk of the passwords with the same hashed value (indicating a weak common password)**
  - Although this may be the case you can still break into the users data using a brute force attack trying every possible combination on the end of the password and then hashing that value
  - This may sound like a huge task but there are massive networks of bot-nets that constantly mine for passwords
  - The best defense of the above attack is to make it so that is is an economically unfeasible endeavor to crack a users password, you should make the cost of breaking a users password to exceed the return of selling the information associated with the user
	- You can do this easily by simply re-running the users hash back through the hashing function
	- This takes a lot of time for us, and thus also costs us money, to do so we shouldn't put the users password through the hashing function a ridiculous number of times
### BCrypt example
- You can play with Bcrypt using `BCrypt::Password.create("#{password}")` in pry
- BCrypt stores the salt and the hash in the same string
- You can check if a value is the password to a `BCrypt::Password` object using `#is_password?(${string})`, this will use the salt and the hash to check the value
  - This is a very expensive method
### Session, flash
- **Session** is a hash that is avaliable to you similar to params
  - You can access the values in this just like the params
  - The session is a tamper-proof version of cookies
  - cookies are not permanent and last a very maximum of 20 years
- You can set a cookie to expire much earlier. Using Rails you can create a **flash** cookie that only lasts for a single request
  - You can even use flash to send a cookie that only lasts for the current request
	- This is actually technically not a cookie because it isn't persistent
### Auth Pattern
- You should never use your own authentication, its a bad idea, very very smart people have spent years doing nothing but figuring out how to do authentication well, you should just use theirs
- With that said, here is how authentication works:
  - When you go to save the users password you word do something like create a beaker password based on the users input after they send over their password, so we would save their hashed password rather than the plain text password. This allows us to store a version of the users password without storing their actual password
  - You also will take their session using `generate_session_token` `ensure_session_token!` and `reset_session_token!`
  - You use the session token to determine who the user is
  - You will need some kind of redirect if the user is not logged in
### CSRF attacks
- These are attacks that are from a foreign sight that is forging a request as the user in order to gain access to their account
- These attacks only work if the user is signed in
### CSRF protection
- To build protection against a CSRF attack you can use a randomly generated token that will be stored in the HTML form and the session using `self.session[:_my_csrf_token] ||= SecureRandom::urlsafe_base64`
- The form will then check that the token from the session matches the token that we generated
  - This validation will do nothing if the token given with the request is the same as the same as the token saved from the session, else it will raise an error
  - This type of check should only happen for post request
	- This is because we only care about requests that can do a malicious action
- But you don't have to do any of this yourself because rails has it built in
  - Rails has it named as `protect_from_forgery with: :exception`
	- This will install a before filter that checks the request type
	- The old default here is no log the user out of the session rather than raising an exception, this is bad and confusing but is still sometimes the way CSRF protection is being implemented on older rails projects
