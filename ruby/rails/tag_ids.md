# Tag-ids in rails
- You can set tag ids instead of saving the actual string value of an input that you know will always correspond to the same ids, this allows for faster data lookup and more effective storage
- This is especially helpful for data lookup because SQL won't have to compare each individual string with the desired value, but instead do a much faster number comparison.
- This requires some extra setup:
  - The tagging will require a separate 'tagging' class
	- This class should have an association with the cat that saves the values of the tagging with the `cat_id`
  - You will have to add check-boxes
	- You can save these using square brackets to save all the inputted values as an array
    - These will need to return an empty array even if no tag is selected, you can do that with the following line in the html file:
```html
<input type='hidden' name='cat[tag_ids][]' value=''>
```
  - You will have to setup translation of the values into stored tags
  - You will have to setup an inverse association for the cat because the tagging will not allow for saving until the cat is in the database and you should save the cat to the database at the same time as the ids to prevent dataloss
    - You can do this by validating the existance of the **cat** object itself rather than the `cat_id`
## Concerns
- A concern is a module that allows us to add class methods, instance methods, and run code at class definition time.
- Concerns are commonly used in rails to group the code needed to add a feature
- This way if you want to add a feature all you have to do is extend it to the concern
- This is very handy when writing polymorphic associations
Code example:
```ruby
# app/models/concerns/taggable.rb
# file name must be the same as our module's name
module Taggable
  # this module becomes a concern thanks to this line
  extend ActiveSupport::Concern

  # code in this block will be run in class scope when the concern is included
  included do
    # validations and associations usually go here
    has_many :taggings, as: :taggable
    has_many :tags, through: :taggings
    validates #...
    # etc
  end

  # tags_string will become an instance method
  def tags_string
    tags.map(&:name).join(', ')
  end

  # methods defined in here become class methods
  module ClassMethods

    # this will become a class method
    # it should return all the elements that are tagged 'tag_name'
    def by_tag_name(tag_name)
      self.joins(:tags).where('tags.name' => tag_name)
    end
  end
end

# app/models/question.rb
class Question < ApplicationRecord
  include Taggable
  # ...
end

# app/models/answer.rb
class Answer < ApplicationRecord
  include Taggable
  # ...
end
```
