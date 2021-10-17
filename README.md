# DBZ: Cell Arena

The following technical sample provides documentation for major functionalities of a ROBLOX battlegrounds game I worked on during the summer of 2020. Minor features and functionalities have been excluded in the documentation, however the whole project is available in the `game` folder.

## Documentation

### 1. Entering the Game
![entering-the-game](/img/entering-the-game.png)

The relevant code for the `STATS` is located in `StarterGui > ScreenGui > Stats > Stats.lua`. The values for yen, kills, and damage are stored using a data persistence API provided by ROBLOX and then output to the `STATS`.

The relevant code for the `STORE` is located in `StarterGui > ScreenGui > Menu > Store > StoreToggle.lua`. This script allows users to press the `STORE` button to open up the store. See below for more details on the store.

The relevant code for the `SAVE` is located in `StarterGui > ScreenGui > Save > SavingInformation.lua`. This script allows users to press the `SAVE` button to save their current in-game progress (for current earned yen, kills, and damage). It's important to note that this `SAVE` button is just for peace of mind as the game automatically saves when the user quits the game.

The relevant code for the volume is located in `StarterGui > ScreenGui > Mute > MuteToggle.lua`. This script allows users to press the volume button to toggle whether they want the soundtrack to be on or off. The script for the playing soundtrack is located in `StarterGui > Soundtrack`. It takes in the asset ID for the soundtrack and plays it.

On the bottom right of the screen, information for the current location is displayed using a text label.

### 2. Store
![store](/img/store.png)

The relevant code for the the `x2 YEN` is located in `StarterGui > ScreenGui > Menu > StoreMenu > DoubleYen > DoubleYen.lua`. This script uses the marketplace service, which is an API that allows for users to use in-game currency (not to be confused with yen) to purchase a yen multiplier that allows users to earn yen double the rate of normal.

The relevant code for the information box is located in `StarterGui > ScreenGui > Menu > StoreMenu > YenInfo > YenInfo.lua`. This information box provides information to the user on how much yen they earn per damage done.

The relevant code for the the `100 YEN` is located in `StarterGui > ScreenGui > Menu > StoreMenu > OneHundredYen > OneHundredScript.lua`. This script uses the marketplace service to purchase one hundred yen. Yen can be used to purchase other characters.

### 3. Character Selection
![character-selection](/img/character-selection.png)

character

uses

### 4. Select/Purchase Character
![select-character](/img/select-character.png)

price

teleport

### 5. Enter Battlegrounds
![spawn-character](/img/spawn-character.png)

moves: melee, transform, beam

new location, removed store and stats

### 6. Melee
![melee](/img/melee.png)

melee script, explain animation and hit box

### 7. Transformation
![transform](/img/transform.png)

transform script, explain power boost and transformation, cooldown

### 8. Blast
![blast](/img/blast.png)

beam scripts, explain script functionality, and look, charging

### 9. Damage
![damage](/img/damage.png)

hit animation, hit tags placed, damage counter to stats, kills, etc

### 10. Stats
![stats](/img/stats.png)

global stats and battle stats