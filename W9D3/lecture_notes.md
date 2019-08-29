# Lecture notes
`<% will execute but not print %>`
`<%= will execute and print %>`
## `BleatsController#new` and `#create`
- new will be used to get the input data from the user, this will just be a show request
- This will send the info to create after the user submits the input
- Its convention to give the input the name of `${controller}-${parameter-name}`
- Don't try to render and redirect at the same time
  - Trying to redirect twice also won't work
- When a post request fails to save we should:
  - Tell the user why
  - Return a new form pre-populated with the data they tried to use as input
- On the form page you have to specify where you want to hit the server after your submit the form
  - This is specified in the `form` tag and should match the correct action's route
  - **This is a really easy place to mess up**
## `BleatsController#edit` and `#update`
- Browsers can't natively handle `PUT` requests, they only support `GET` and `POST` requests, so we have to set the method to `POST` in the `form` tag and then tell rails that you are trying to make a `PUT` request through the following: 
  ```html
	<input type="hidden" name="_method" value="PUT">
  ```
- You can use either POST or PATCH on the assessment on the assessment because they have the same functionality

## Partials
- **Its best practice to not use any instance vars inside of partials**
- to give the partial access to tho instance vars you can use the following:
```html
<%= render partial: "form", locals: {bleat: @bleat} %>
```
- This is basically just defining bleat within the partial to be holing the value contained by @bleats
- Its very common to have each separate list item to be a different partial
- **The assessment can be done entirely without partials so don't use them if you don't fully understand them**
## `BleatsController#destroy` and general housekeeping
- If you want to access any route that isn't a `GET` request you need to use a form
