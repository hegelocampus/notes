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
- Projects vs. apps
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

