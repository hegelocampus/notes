# Rails
## General Setup
- The annotate gem is helpful for quickly adding the schema information to the
  model file
- Also a good idea to add the pry-rails gem
- Within the rails console you can use Object.methods to show all the methods
  that you can use on your object
## Migrations
- Migrations are about changing the structure of the db and not about actually
  adding data
- Migrate is used to make changes to the db
   - use bundle exec rails generate migration ${migration name}
- Whenever you create a table you should add  t.timestamps
   - You will be thankful someday
- bundle exec rails db:migrate to actually implement the migration
- ***Avoid using rollback whenever possible***
   - It is much better practice to add a new migration that fixes the changes
## Models
- Models file needs to be the singularized version of the table name
- To declare that a file in the model dir is not a model use self.ablstact_class =
  true
- This will makeit so rails doesn't try to relate the class to a table
## Associations
- The side that has the fogeign key has the belongs_to keyword/method
   - has_many is constructed as follows
   ```ruby
    class User < ApplicationRecord

      has_many :authored_bleats,
        class_name: "Bleat",
        primary_key: :id, #<- This will almost always be id
        foreign_key: author_id

      belongs_to :location,
        class_name: 'Location',
        primary_key: :id,
        foreign_key: :location_id
   ```
  - Can do through associations that link two tables that are not dirrectly
  associated
    ```ruby
    class Location < ApplicationPecord
      has_many :users,
        class_name: "User",
        primary_key: :id,
        foreign_key: :location_id
      has_many :bleats,
        through: users, #<- This is the jump we need to take to link the
        desired tabe
        source: :authored_bleats
    ```
  - It is a good idea to add indicies onto foreign keys because they are
  typically frequently accessed using joins and the incicies greatly speed up
  finding an object in joined table
    - rails will use the foreign id instead of joining if it is avaliable
## Validations
- Validations are about ensuring that we always have good data in our db
- Validations prevent invalid data from being set at all in the db
- If the data is found to be invalid then the changes will be immedietely rolled back
- Errors are checked for when you try to set the new data values in your database or when you use the ApplicationRecord#valid? method
  - You can see the errors displayed using ApplicationRecord#errors.full_messageApplicationRecords
  - **Associations are implicity required**
  - Make sure you set `optional: true` if you want an association to be optional
  - Built in validation looks like this:
    ```ruby
    class Bleat < ApplicationRecord
      validates :body, length: {maximum: 150}
    end
    ```
  - You can create a custom validation as follows:
    ```ruby
    class Bleat < ApplicationRecord
      validate :ensure_bleats_arent_long

      def ensure_bleats_arent_long
        self
        if self.body && self.body.length > 150
          self.errors[body] << "is too long (max is 150 chars)" #<-This will return the message as an error if length > 150 
        end
      end
    end
    ```
## Seeding
- You can set up the ../db/seeds.rb in order to seed a test db
- Should start each db's construction with a #destroy

## Association Methods & #joins
  - Queries are lazy evaluated
   - This means they are not actually run in SQL until the data needs to be
   accessed
  - #joins will always use inner joins
  - You can pass #joins one of your associations as a symbol to automatically
  join based on how you setup the association
## #includes
  ex:
  ```ruby
    def self.print_all_bleats_by_location
	  Location.includes(:users).all.each do |location|
	    location.users.each do |user|
		user.authored_bleats.each do |bleat|
		  puts "#{ user.emails } (#{ location.name }): #{ bleat.message }"
		end
	  end
	end
  ```
  - You can use includes to streamline the queries to reduce the number of queries that are ran within an iteration.
  - Querrying is the most expensive operation, so we should reduce the amount of
  queries preformed to the bare minimum
  - You can do nested #includes just like nested joins.
    e.g.,
	```ruby
    def self.print_all_bleats_by_location
	  Location.includes(users: :bleats).all.each do |location|
	    #...
	  end
    end
	```
