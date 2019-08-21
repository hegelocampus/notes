#Rails Notes Day 2
##General notes

##Association Methods & #joins
  -Queries are lazy evaluated
   -This means they are not actually run in SQL until the data needs to be
   accessed
  -#joins will always use inner joins
  -You can pass #joins one of your associations as a symbol to automatically
  join based on how you setup the association
##\#includes
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
  -You can use includes to streamline the queries to reduce the number of queries that are ran within an iteration.
  -You can do nested #includes just like nested joins.
    e.g.,
	```ruby
    def self.print_all_bleats_by_location
	  Location.includes(users: :bleats).all.each do |location|
	    #...
	  end
    end
	```
