# End of day notes
- JS doesn't have hash defaults
  - You can use `hash[key] = hash[key] || 0` to set the value to 0 to setup a counter
- `push()` returns the length of the new array?????
- You need to explicitly invoke `shift()` using empty parentheses
- If you use map make sure you explicitly return the new value
- When importing you need to set the values imported using a key:value pair
```javascript
//./game.js
//This must be done at the very bottom of the file
module.exports = { Game };
// or
module.exports = Game;
//./playScript.js
const { Game } = require('./game.js');
// or
const Game = require('.game.qs');
```
