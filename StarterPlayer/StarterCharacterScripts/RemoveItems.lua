--[[ SCRIPT REMOVES PLAYER'S TOOLS ]]--

local Players = game:GetService("Players")

--------------------------------------------------------------------------------

local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Player = Players:GetPlayerFromCharacter(Character)
local Backpack = Player:WaitForChild("Backpack")

--------------------------------------------------------------------------------

local function RemoveItems(Container)
	for _, Item in pairs (Container:GetChildren()) do
		if Item:IsA("Tool") or Item:IsA("ParticleEmitter") or (Item.Name or Item:GetPropertyChangedSignal("Name"):Wait()) == "EnergyBurst" then
			Item:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

Humanoid.Died:Connect(function()
	RemoveItems(Character)
	RemoveItems(HumanoidRootPart)
	RemoveItems(Backpack)
end)