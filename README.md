# DBZ: Cell Arena

The following technical sample provides documentation for major functionalities of a ROBLOX battlegrounds game I worked on during the summer of 2020. Minor features and functionalities have been excluded in the documentation, however the whole project is available in the `game` folder.

## Documentation

### 1. Entering the Game
![entering-the-game](/img/entering-the-game.png)

When the player enters the game, the server script (`ServerScriptService > ServerScript`) sets up the player's saved data.

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

Upon walking forward, the player will notice several characters of which they can select from. The number of times used for each character is located above the character's heads to show the user how many times they have used a certain character. The script for this is located in `StarterGui > Uses.lua`.

### 4. Select/Purchase Character
![select-character](/img/select-character.png)

Here, we have chosen Goku as a sample character to select out of the many. Note that the area where it says `OWNED` was originally the price of Goku. Stepping on it when the price is displayed would purchase Goku, but stepping on it when it says `OWNED` will teleport the player using the morph script (`ServerScriptService > MorphScript`).

### 5. Enter Battlegrounds
![spawn-character](/img/spawn-character.png)

Once the player has teleported, they will notice that their character has transformed into Goku. They would also observe that they have gained three tools: a melee attack, transformation, and beam attack. This is all done with the MorphScript (`ServerScriptService > MorphScript`). The morph script also changed the location text label on the bottom right, and removed the store and stats GUI.

### 6. Melee
![melee](/img/melee.png)

The relevant code for the melee attack is located in `ServerStorage > MeleeMove > MeleeMove.lua`. This attack involves a left/right punch/kick animation that creates an invisible hit box. If another player enters the hit box, they will receive damage from the user.

### 7. Transformation
![transform](/img/transform.png)

The relevant code for the transformation move is located in `ServerStorage > Transformation > Transformation.lua`. This move allows the user to transform into an ascended state of their current character, which increases their strength and speed. It also gives them a shiny aura and may even change their hair to yellow. Once the form timer runs out, there is a cooldown before you can activate it again.

### 8. Blast
![blast](/img/blast.png)

The relevant code for the blast/beam attack is located in `ServerStorage > KiBeam > KiBeam.lua`. This move charges up a blast/beam and then when the user lets go off their mouse, it launches a large blast/beam attack. This attack first creates a ball object which tweens larger and smaller. When the user lets go off their mouse, this ball object disappears and a cylinder and larger ball object is created. First, the player faces the direction to where their mouse was let go (uses CFrame along with the `StarterPlayer > StarterPlayerScripts > Mouse.lua` script), then a cylinder tweens forward in length and so does a large ball relative to the cylinders end position. Once the large ball hits another object, it explodes. Like the transformation, there is a cooldown before this move can be used again.

### 9. Damage
![damage](/img/damage.png)

The damage property in this game is used in both the melee and blast/beam attack. 

hit animation, hit tags placed, damage counter to stats, kills if health below 0, etc

### 10. Stats
![stats](/img/stats.png)

global stats and battle stats, remove items, character added, remove buttons `StarterPlayer\StarterPlayerScripts\RemoveButtons.lua` `StarterPlayer\StarterCharacterScripts\RemoveItems.lua` `StarterPlayer\StarterCharacterScripts\CharacterAdded.lua`