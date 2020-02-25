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
