# Redux Sagas
- Redux Sagas are an alternative to Redux Thunks
- How to preform an async action using Sagas (e.g., an AJAX request):
  - Dispatch an event with the desired `<String>action` along with the `<Object>data` needed
  - That event is then intercepted by the Saga middleware which then triggers the designated `Function*` Saga function
- Analogy:
  - Redux Thunks:
	- Sending an empty facility a big box in the mail that has the tools that are needed to make a thing you want.
  - Redux Sagas:
	- Sending a facility, that already has all of the tools required to perform the required task, a letter detailing what you want made.

