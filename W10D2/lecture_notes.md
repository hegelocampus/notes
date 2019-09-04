# CSS
- Floats suck don't ever use them if you have a choice
## Flex Box
- Flex is great but has limitations
- `flex-wrap`
  - `nowrap` is the default, it puts everything no one line
- `justify-content`
  - `space-between` evenly puts space between the elements but does not put space on the outside
  - `flex-around` evenly puts space between and around all elements
- `align-items`
  - `flex-start` will crunch all elements up towards the top of the container
  - `baseline` all items are aligned on their first element
  - `stretch` stretches element vertically to the size of the container
- To move a particular item you can change the following on the object:
  - `order` takes a number lower numbers get placed first
  - `flex-grow` takes a number and causes the element to grow when the container they are in is expanded
	- The ratio of how much the element grows is determined by the number given
  - `flex-shrink` is the same but for shrinking the container
- You can modify multiple settings with just using `flex`: #{flex-grow} #{flex-shrink} #{basis}
## Position
- `position: relative` moves an object based on its normal position. You can move things around using the following tags:
  - `bottom`
  - `top`
  - `left`
  - `right`
- `position: absolute` causes an element to shrink to the size of its contents
  - When you shift an absolute object it moves based on the position of the first non-statically positioned parent
  - If it doesn't find something it positions itself based on the window
  - You should make the position of the **parent** of such objects **relative**
	- This will make the absolute object much easier to position
- `position: sticky` causes the element to stay in place until you scroll to where it would be off the screen, then it sticks 
## CSS on Rails
- All CSS should go in the `app/asseets/stylesheets` directory
- The `application.css` file is a manifest file
- You can write css-reset stuff there
- Use `z-index: n` to set the stacking order (layer order)
# Evening lecture notes
## A04
- The specs won't validate the uniqueness of the password
** This isn't an assessment thing** there is no reason why we shouldn't reset the session token after ever request
