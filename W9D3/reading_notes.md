# Rails Views
## Intro 
- New HTML files that you want to display will be in `app/views/${table_name}/${action_name}.html.erb`
- You will then just need to do `render :index`
- **Instance variables** that you define in the **controller** that calls the action will all be avaliable in the `html.erb` file
- In the `html.erb` file you will need to use `<% %>` to write ruby code that **will not** be printed or `<%= %>` to write ruby code that **should** be printed
E.g.,
```ruby
<ul>
  <% @books.each do |book| %>
    <li><%= book.title %></li>
  <% end %>
</ul>
```
***If you want to comment out ruby code you will need to use a ruby comment inside of an HTML comment***
- Its good practice to redirect the user to a different action if your action fails
  - You can do this with `redirect_to`, this returns a 300-level response back to the client, which has them make a new request to our site
  - Generally if we are in the action of the item that we want to render we will just render it, if we are in a different action we should render instead
  - Keep in mind that render and redirect are not method ending, (I.e., they do dot act like a return), so if you use two in the same terminal thread of a method you will return an error
- If theres anything you want at the top of every page you can use 
## Using forms with views
- To create a new item we would do something like follows
```html
<!--/new.html.erb-->
<h1>Add book to Library!</h1>
<form action="/books" or < method="post># This is where you tell rails where to send the input. Here it is the controller book and post request type
  <label for="title"></label>
  <input id="title" type="text" name="book[title]"># This is where we tell rails how te return the input

  <label for="author">Author</label>
  <input id="author" type="text" name="book[author]">

  <label for="year">Year</label>
  <input id="year" type="text" name="year[year]">

  <label for="category">Category</label>
  <select name="book[category]"> 
  <!-- This creates a dropdown menu -->
    <option disabled selected>-- Please Select --</option> 
	<!-- The above is good practice to force the user to select an option -->
    <option value="Fiction">Fiction</option> 
	<!-- The two fictions here do not actually have to be the same word whatsoever -->
	<option value="NonFiction">NonFiction</option>
  </select>

  <label for="description">Description</label>
  <textarea name="book[description]"></textarea>
  <!-- This creates a text book for the user -->

  <input type="submit" value="Add book to library"># This will package the info in the form and send it /books as a post request
</form>
```
```ruby
#/app/controllers/books_controller.rb

def BooksController
  def create

    #@book = Book.new(params[:book]) # This will take in the submitted params and use them to create a new book
```
**The above way is vulnerable to injection attacks**  
Its best practice to only permit the values you actually want in a params helper method
```ruby
    @book = book.new(book_params)
	if @book.save
	  #show user the book show page
	  redirect_to book_url(@book)
	else
	  #show user the new book form
	  render :new
	end
  end

  def book_params
    params.require(:book).permit(:title, :author, :year, :description, :category)
  end
end
```

## Update Method and Partials
- How to allow a user to edit the database from a form without having to create a new object
- `PATCH` is the method you will use for making modifications
- As always this will involve making a new `edit.html.erb` file and defining the proper action in the `controller` file
  - You should get the object you want to edit using `@book = Book.find_by_id(params[:id])`, id will come from the URL
  - After you expose the variable to the HTML file using `<%= book_url(@book) %>` you can access the values contained in it by using the `value` tag
	- This can be used to fill in a form with the original data on the table for the object that is being modified
  - **Be very careful to put these in the _`:development group`_ only**
	- If you put it in the live version of the server then anyone can get access to the live shell by just causing an error
- To create a **partials** in rails you can start an `*.html.erb` file with an **underscore**, e.g., `_form.html.erb`
  - These files are filled with templates that you can use to dry up your code
  - This is useful for drying up the input and update `html` sheets by combining them
  - **Make sure you pass in locals rather than use instance variables**. Partials have access to controller instance variables so you can do unexpected things if you try to use instance vars
## Debugging
- Debug with the actual displayed webpage and the rails server
  - The rails console is also a great debugging tool, you can use it you hit a particularly tough bug
  - the `gem 'binding_of_caller'` will drop us into the rails console if you hit an error, this is very helpful for debugging
	- You can use the `fail` keyword to force this gem to trigger the console where you want it
- Routing Errors are very common
  - What route was I trying to go to?
  - What route were you trying to go to?
  - And why were you trying to go there?
- Parameters issues are very common, the params will be shown in the rails server logs

