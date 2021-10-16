--[[ DISPLAYS PRICE ]]--

local OWNED_CELL_SAGA_ENCODED
local OWNED_CELL_SAGA

--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local OwnedCellSagaPlayers = Player:WaitForChild("OwnedCellSagaPlayers")
local HttpService = game:GetService("HttpService")
local Lobby = workspace:WaitForChild("Lobby")
local CharacterSelection = Lobby:WaitForChild("CharacterSelection")

--------------------------------------------------------------------------------

local function Text(NAME, PriceTag, YEN)
	if OWNED_CELL_SAGA[NAME] then
		PriceTag.Text = "OWNED"
	else
		PriceTag.Text = YEN
	end
end

--------------------------------------------------------------------------------

-- Initialize values.

OWNED_CELL_SAGA_ENCODED = OwnedCellSagaPlayers.Value or OwnedCellSagaPlayers:GetPropertyChangedSignal("Value"):Wait()
OWNED_CELL_SAGA = HttpService:JSONDecode(OWNED_CELL_SAGA_ENCODED)

--------------------------------------------------------------------------------

for _, Morph in pairs (CharacterSelection:GetChildren()) do
	local MorphCharacter = Morph:WaitForChild("MorphCharacter")
	local YenCost = MorphCharacter:WaitForChild("YenCost")
	local Tile = Morph:WaitForChild("Tile")
	local SurfaceGui = Tile:WaitForChild("SurfaceGui")
	local PriceTag = SurfaceGui:WaitForChild("PriceTag")
	
	local NAME = Morph.Name or Morph:GetPropertyChangedSignal("Name"):Wait()
	local YEN = YenCost.Value or YenCost:GetPropertyChangedSignal("Value"):Wait()
	
	OwnedCellSagaPlayers.Changed:Connect(function()
		
		-- Reinitialize values.
		
		OWNED_CELL_SAGA_ENCODED = OwnedCellSagaPlayers.Value or OwnedCellSagaPlayers:GetPropertyChangedSignal("Value"):Wait()
		OWNED_CELL_SAGA = HttpService:JSONDecode(OWNED_CELL_SAGA_ENCODED)
		
		--
		
		Text(NAME, PriceTag, YEN)
	end)
	
	Text(NAME, PriceTag, YEN)
end