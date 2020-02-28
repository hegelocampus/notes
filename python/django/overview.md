# Overview
## Basic app creation
- You can setup a basic Django project in the directory `foo` using the following command:
```bash
$ django-admin startproject foo
```
This creates the following directory structure:
```
foo/
  manage.py
  foo/
	__init__.py
	settings.py
	urls.py
	asgi.py
	wsgi.py
```
- `manage.py` is a command-line utility that lets you interact with the project in various ways
- The inner `foo` directory is the actual Python package for your project
- `foo/__init__.py` is an empty file that tells Python that this directory is a Python package
- `foo/settings.py` is the Django configuration file
- `foo/urls.py` sets up the URL declarations for the project
- `foo/asgi.py` is the entry point for ASGI-compatible web servers to serve your project
- `foo/wsgi.py` is the entry point for WSGI-compatible web servers to serve your project
## The development server
You can start the dev server with the following command:
```
$ python manage.py runserver
```
- It runs by default on port 8000, you can run it on a custom port by passing the desired port as an argument
- This server performs hot reload on each request (as needed). So you don't need to restart the server for (most) changes to take effect, although you will need to restart the server for file additions.
- Projects vs. Apps
  - Apps are atomized pieces of the application that perform a specific task. Can be in multiple different projects.
  - Projects are collections of configuration and apps for a particular website. Can contain multiple apps.
- Apps can exist anywhere in your Python path
- At your project's root directory you can use `python manage.py startapp bar` to generate the directory structure for a new app
  - This would create a subdirectory `foo/bar` that contains your new app
## Views
- Views are defined in the individual apps in their `views.py` file
- To call a view you need to map it to a URL.
  - To do this you will need to define the path in URLconf file `foo/bar/urls.py`
  - And then you'll need to also define the path in the `foo/foo/urls.py` file
	- Here you will use `include` to reference the URLconf from `polls` using `include('polls.urls')`
	- The only exception where you should not use `include` is the `admin.site.urls` path
- The `path()` function is passed four arguments, two required: `route` and `view`, and two optional: `kwargs` and `name`
  - `route` is a string containing a URL pattern. Django starts at the first pattern and makes it's way down the list until it finds a match. The pattern doesn't get the GET and POST parameters or the domain name. So for example `https://www.example.com/foo/?page=3` will simply get translated to `foo/`
  - `view` this is the function that will be called if there is a match. This function is passed the same `HttpRequest` object that was passed to the root function.
  - `kwargs` is arbitrary keyword arguments that can passed in a dictionary to the target view. This is a more advanced feature and you probably won't use it right away
  - `name` naming your URL lets you refer to it unambiguously from elsewhere in Django. This is particularly useful from within templates.
## Database setup
- The database is defined in the `foo/foo/settings.py` file
  - The default is `SQLite`, which is included by default in Python.
  - To use a different database you will have to install the appropriate database bindings and then change the following keys in the `DATABASES` `'default'` item to match your database's connection settings:
	- `ENGINE`: 
	  - `'django.db.backends.sqlite3'`
	  - `'django.db.backends.postgresql'`
	  - `'django.db.backends.mysql'`
	  - `'django.db.backends.oracle'`
	- `NAME`: The name of your database
	  - For SQLite this will be the name of the file on your computer, so this would be the absolute path to the file. You can construct this using the default value of `os.path.join(BASE_DIR, 'db.sqlite3')`
	- If you're not using SQLite you will also have to define `USER`, `PASSWORD`, and `HOST`. The [`DATABASES` documentation](https://docs.djangoproject.com/en/3.0/ref/settings/#std:setting-DATABASES) contains more information about this.
  - During this setup phase its also a good idea to set `TIME_ZONE` to your time zone (which is `'America/Los_Angeles'`
  - `INSTALLED_APPS` is also of note. It holds the name of all Django applications that are activated in this Django instance.
- To create the database table use the following command:
```bash
$ python manage.py migrate
```
This command looks at the `INSTALLED_APPS` setting and creates any necessary tables according to the database settings
## Creating models
- A model is a single, definitive source of truth about your data. It contains the essential fields and behaviors of the data you're storing. **This includes the migrations.**
  - **Unlike Ruby On Rails, migrations are entirely derived from the models file**
- Each model is represented by a class that subclasses `django.db.models.Model`. Each Model can have a number of class variables that each represent a database field in the model.
  - Each database field is represented by an instance of the `Field` class, e.g., `CharField` and `DateTimeField`
  - The name of each `Field` instance is the field's name, you can change this to a human-readable name using the first argument, e.g., `models.DateTimeField('date published')`
  - Some `Field` classes have required arguments. 
	- `CharField` requires that you give it a `max_length`. This is not only used in the schema but also during validation
  - You can use `ForeignKey` to define a foreign key (duh). Django supports all the common database relationships (many-to-one, many-to-many, and one-to-one)
## Activating models
- Django uses the models to create the database schema and also create the Python database-access API for accessing the Objects of the models.
- To include the app in the project you need to add a reference to its configuration class in the `INSTALLED_APPS` setting.
You then have to actually perform the migration using the following command:
```bash
$ python manage.py makemigrations appName
```
- Running `makemigrations` is telling Django that you've made changes to your models and you need those changes stored as a migration.
- Migrations are how Django stores changes to your models. These actually exist as files but you're not really expected to read them, although these files are designed to be human-editable (just like rails).
- If you want you can print the exact SQL migration produced by using the following command:
```bash
python manage.py sqlmate appName 0001
```
You can also use `python manage.py check` to check for any problems that may be created by running the migrations or otherwise touching the database.  
Once you're ready to actually make your migrations you can do so through the following command:
```bash
$ python manage.py migrate
```
### Clear steps for creating models
- Change he models in `models.py`
- Run `python manage.py makemigrations` to create the migrations for those changes
- Run `python manage.py migrate` to apply those changes
### Playing with the API
- You can open up the iterative python shell and play with the Django API using `python manage.py shell`
  - This is basically equivalent to the `rails console`, the biggest difference is you have to manually import what you want to mess with, e.g., use `from exampleApp.models import Foo, Bar`
  - A super helpful method is `help()`, which you can run on any of your defined classes in order to see a breakdown of the methods they have defined for them, their parameters and instance variables.
- You can use this to test queries on your database, e.g., `Question.objects.all()`, this is also nearly identical to Rails where you would run `Question.all()` to get the equivalent query
- You can create a new model object through creating a new class instance and then using `foo.save` to actually save it to the database (just like in Rails)
- You can change the values in the database by reassigning the instance variables and then calling save again, e.g., `foo.question_text = "Hello"` and then `foo.save()`
- To get useful representations of the data in your database you should add a `__str__()` method to your models. **This is actually pretty important**
- To query for a particular field you can use `Foo.objects.filter(id=1)` or `Foo.objects.filter(question_text__startswith='What')` returns a set of Query objects, to query for a single object you can use `Foo.objets.get()` which just return a single Query object
  - You can use the `pk` shortcut to search by primary key
  - If you try to request something that doesn't exist it will raise an exception
- For info on associations you can check out the [doc page on accessing related objects](https://docs.djangoproject.com/en/3.0/ref/models/relations/)
## Django Admin
- You can create a super user with `python manage.py createsuperuser`
- The default admin URL is at "/admin/" on your domain
- The types of Groups and Users here are provided by `django.contrib.auth`
- To make any of your apps modifiable in the admin you must tell the admin that Question objects have an admin interface. This is done in the `appName/admin.py` file. You can do this in the following way:
```python
from django.contrib import admin

from .models import Question

admin.site.register(Question)
```
- By allowing admin interface with a model there will be an interface added where you can edit any of the information of the database objects with a form that is generated via the models properties
  - Any changes will be logged in the admin history, which can be found in the upper right of the admin portal.
## Views
- A view is a "type" of Web page in your Django app that generally serves a specific function and has a specific template.
- Web pages and other content are delivered by views. Each view is represented by a Python function (or method, in the case of class-based views).
- The routing from URL to view is setup in the `URLconfs`
- Views are defined in `appName/views.py`
- You can use angle brackets to "capture" part of the URL to pass it in as a parameter to the view, e.g., `path('<int:question_id>/', views.detail, name='detail')` would pass in the parameter `question_id`
- Each view is responsible for doing one of two things:
  - Returns an `HttpResponse` object containing the content for the requested page
  - Or Raising an exception such as `Http404`
- Views can read records for the database, or not. It can really do anything you want as long as you return either an `HttpResponse` or an exception
### Templates
- You can define templates that can be called from the views... Just like in Rails
- These templates live in `app_name/templates/model_name/view_name.html`
- It's best practice to define the variables that you'll need in the template in a `context` dictionary map.
- You can get a shortcut to the template using the `render()` method, it takes the following parameters:
  - `request` 
  - Template name as a string 
  - The context object of variables that need to be accessible to the template.
### Raising a 404 error
- You actually raise the exception in the view function/method, you can wrap the code that may fail in a try block and then raise the error in the `except` conditional, e.g.,
```python
def detail(request, question_id):
	try:
	    question = Question.objects.get(pk=question_id)
	except Question.DoesNotExist:
	    raise Http404("Question does not exist")
	return render(request, 'polls/detail.html', {'question': question})
```
- There's a shortcut for this too, its `get_object_or_404()`. This method raises a 404 not found error if the object you are attempting to fetch doesn't exist. It accepts a Django model as its first argument an arbitrary number of keyword arguments to be passed to the `get()` function call
  - There's also `get_list_or_404()` which uses `filter()` instead of `get()` and raises a `Http404` error if the list is empty.
### Using the template system
- The template system uses dot-lookup syntax to access the variable attributes
- Python method-calling happens in `{% foo %}` blocks. 
- You can read more about templates in the [template guide](https://docs.djangoproject.com/en/3.0/topics/templates/)
### Removing hardcoded URLs in templates
- Its best practice to use the following to create links for anchor tags:
```django
<li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
```
- This allows for the tag to look up the URL definition as it is specified in the `URLConfig`
### Namespacing URL names
- This is done through simply adding an `app_name` to the apps URLconf
- Then you need to refer to the desired URL in the template thorough its namespaced URL, e.g., `polls:detail` rather than just simply `detail`, this seems more complicated but otherwise Django won't know which URL you want if you have multiple apps
## Forms
- **Remember the** `csrf_token`
- Make sure to define the form's `method` as `post` or `patch`
- In the view remember to return a `HttpResponseRedirect` after a successful POST request
### Generic Views
- There are a bunch of built in generic views that are great and will save you time
- These generics will need to have a `model` or `context_object_name` and `template_name` instance variables defined
- Generics typically expect the variable they are being asked to fetched to be named `pk` rather than, for example, `question_id`
- By default the `DetailView` generic uses a template called `<app name>/<model name>_detail.html`. The `template_name` attribute is used to tell Django to use a particular template name rather than the default
## Automated testing
- In automated tests the tests are done by the system. This is the type of testing I, personally, think of when I think of code testing.
- You build tests in Django by creating a subclass of the `TestCase` subclass for each element you want to test. This class will have methods defined for each test, e.g.,
```python
class QuestionModelTests(TestCase):
    def test_was_published_recently_with_future_question(self):
        """
        was_published_recently() returns False for questions whose pub_date is
        in the future
        """
        time = timezone.now() + datetime.timedelta(days=30)
        future_question = Question(pub_date=time)
		self.assertIs(future_question.was_published_recently(), False)
```
- Tests are ran through `python manage.py test app_name` just like every other Django command
- Django automatically creates a testing database
How Django runs tests:
- Looks for tests in the stated application
- Looks for a subclass of the `django.test.TestCase` class
- Looks for test methods, whose name must begin with `test`
- Then runs those methods and prints the results
### Testing a view
- You can test a view by using `self.client.get(reverse('polls:index'))` to get the content of the response.
