--[[ DISPLAYS USES ]]--

local USES_CELL_SAGA_ENCODED
local USES_CELL_SAGA

--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local CellSagaPlayerUses = Player:WaitForChild("CellSagaPlayerUses")
local HttpService = game:GetService("HttpService")
local Lobby = workspace:WaitForChild("Lobby")
local CharacterSelection = Lobby:WaitForChild("CharacterSelection")

--------------------------------------------------------------------------------

-- Initialize values.

USES_CELL_SAGA_ENCODED = CellSagaPlayerUses.Value or CellSagaPlayerUses:GetPropertyChangedSignal("Value"):Wait()
USES_CELL_SAGA = HttpService:JSONDecode(USES_CELL_SAGA_ENCODED)

--------------------------------------------------------------------------------

for _, Morph in pairs (CharacterSelection:GetChildren()) do
	local Tile = Morph:WaitForChild("Tile")
	local BillboardGui = Tile:WaitForChild("BillboardGui")
	local UsesLabel = BillboardGui:WaitForChild("UsesLabel")
	
	local NAME = Morph.Name or Morph:GetPropertyChangedSignal("Name"):Wait()
	
	CellSagaPlayerUses.Changed:Connect(function()
		
		-- Reinitialize values.
		
		USES_CELL_SAGA_ENCODED = CellSagaPlayerUses.Value or CellSagaPlayerUses:GetPropertyChangedSignal("Value"):Wait()
		USES_CELL_SAGA = HttpService:JSONDecode(USES_CELL_SAGA_ENCODED)
		
		--
		
		UsesLabel.Text = "USES: "..USES_CELL_SAGA[NAME]
	end)
	
	UsesLabel.Text = "USES: "..USES_CELL_SAGA[NAME]
end