1. [Polls App Solutions](Polls App Solutions)
   1. [results](#results)
   2. [#not_duplicate_response](#not_duplicate_response)
      1. [sibling_responses](sibling_responses)
      2. [respondent_is_not_poll_author](respondent_is_not_poll_author)
2. [Metaprogramming Intro & Class Instance Vars](#Metaprogramming Intro & Class Instance Vars)
   1. [Instance Vars](Instance Vars) 
   2. [Send](Send)
## Polls App Solutions
### `#results`
 - This can be done a number of ways, the most efficient way is a single query way using ActiveRecord
    ```ruby
    acs = self.answer_choices
      .select("answer_choices.text, COUNT(responses.id) AS num_responses")
      .left_outer_joins(:responses) #<- Left outer join will retain the answers that don't have a response
      .group("answer_choices.id") #<- A join is required by the count
      
    acs.inject({}) do |results, ac|
      results[ac.text] = ac.num_responses
      results
    end
    ```
 ### `#not_duplicate_response`
  - Don't want the same person responding to the same question twice
    - We have to check that none of the answers of the parent question are from
        the same user
  #### `sibling_responses`
    ```ruby
    binds = { answer_choice_id: self.answer_choice_id, id: self.id }
    Response.find_by_sql([<<-SQL, binds])
      SELECT
        responses.*
      FROM (
        SELECT
          questions.*
        FROM
          questions
        JOIN
          answer_choices ON questions.id = answer_choices.question_id
        WHERE
          answer_choices.id = :answer_choice_id
      ) AS questions
      JOIN
        answer_choices ON questions.id = answer_choices.question_id
      JOIN
        responses ON answer_choices.id = responses.answer_choice_id
      WHERE
        (NULL IS NULL) OR (responses.id != NULL) /*<- If we retreive a NULL id we have to deal with it in a weird way to prevent SOL from trying to evaluate the second half of the OR statement */
    SQL
    ```
  #### respondent_is_not_poll_author
    ```ruby
    poll_author_id = Poll
      .joins(questions: :answer_choices)
      .where('answer_choices.id ?', self.answer_choice_id)
      .pluck('polls.author_id')
      .first
    ```
## Metaprogramming Intro & Class Instance Vars
  - Using ruby to program ruby
  - Metaprogramming is all about making code modular
### Instance Vars
  - Any object can have its own instance Vars
  - Can check a things vars using `#.instance_variables`
  - you can define a class variable using an @@
    - Class vars should be things you want to persist through the creation of aditional subclasses
    - They are accessible by all the members of that superclass
    - Its best practice to define class variables at the very top of a class
  - you can access an instance variable by name using `#instance_variable_get(:@var)`
    - don't forget the @ before the var name
  - you can set an instance var by name using `#instance_variable_set(:@var,
      :new_val)`
### Send
  - send calls a method directly
  `lola.send(:juggle, "bowling pins", 5)` 
    - This sends #juggle("bowling pins", 5)
  - Send circumvents the privacy rules
    - But this isn't the purpose of send
  - send is useful for dynamically named methods
