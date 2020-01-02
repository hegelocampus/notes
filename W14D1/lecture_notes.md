# Week 14 Day 1 Lecture Notes
## React Router
- The react router allows us to control the url without requiring a full page refresh
- This speeds up the users access to the webpage
- Even manually changing the url will just change the contents of the currently loaded webpage based on the new url, rather than loading a new webpage
### `history.push`
-The browser keeps track of the history on your webpage, this is stored in `window.history`
- You can push new things in the history using `history.push`, this will push the user to a new location
### Front-end Routes with Rails
- If you have rails just render a single html page and handle everything else with the react router then its called a **single page web-app**
- Everything before the `#` will be handled by rails, and everything after will be handled by react
- A single page web-app will just require a single line of actually rendering html in the `./config/routes.rb`: `root to: static_pages#root`
- You will have to create a controller for this static page
- that will just have the following:
```ruby
class StaticPagesController < ApplicationController
  def root
	render root
  end
end
```
- The Router will match all elements that have a path that matches the given
  - You can use `<Route exact path="/foo" />` to circumvent this
- The biggest (and only major) downside of have a single page website is that it doesn't produce search results for any of the pages underneath the root
### `componentDidUpdate`
- When the page is re-rendered but the same element is to be loaded the same instance of page is used but `componentDidUpdate` is ran again, with the previous props passed as args
  - This will not run after the initial render of the page
- This will trigger after the page is rendered and if you change the props then you will trigger a re-render
  - The standard pattern to follow is to check if the props should change and only then should you actually update the props
  - If you don't add this logic then you will end up in an infinite render loop

