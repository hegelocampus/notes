# The Big Picture
## Users
- A _user_ is an entity that can run processes and own files.
- A user is associated with a _username_, but the system doesn't identify users with usernames, it uses numeric _userids_
- Users exist primarily to support permissions and boundaries.
- Every user-space process has a user _owner_, processes are said to run _as_ the owner (e.g., `sudo dd` runs _as_ root).
- root
  - root is an exception to many rules on users
  - root may terminate and alter any user's processes and read any file on the local system.
  - A person that can operate as root is said to have _root access_
- Groups are sets of users. They primarily exist to allow a user to share file access to other users in a group.

