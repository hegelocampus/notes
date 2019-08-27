# Reading Notes
## Callbacks
- Callbacks are methods that get called at certain moments of an object's life cycle.
- Relational callbacks are important because they allow you to clean up (delete) objects that were created/owned by the other object
  - You can do this by passing the `:dependent` option to `has_many`
    - This destroys the dependent obj, if you don't want that you can use `dependent: :nullify`, this will just set the objects foreign key to `NULL`
- To guarantee **referential integrity** you should enforce constraints at the DB level, otherwise you will be able to make modifications to the SQL data by bypassing `ActiveRecord`
# DNS (Domain Name System)
- This is what translates domain names to IP addresses
