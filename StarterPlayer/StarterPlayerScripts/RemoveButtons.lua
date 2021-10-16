--[[ SCRIPT REMOVES MOBILE BUTTONS ]]--

local ContextActionService = game:GetService("ContextActionService")

--------------------------------------------------------------------------------

local PlayerScripts = script.Parent
local Player = PlayerScripts.Parent
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

--------------------------------------------------------------------------------

local function UnbindButtons()
	ContextActionService:UnbindAction("DPadUp")
	ContextActionService:UnbindAction("DPadLeft")
	ContextActionService:UnbindAction("DPadDown")
	ContextActionService:UnbindAction("DPadRight")
	ContextActionService:UnbindAction("ButtonL2")
	ContextActionService:UnbindAction("ButtonA")
end

--------------------------------------------------------------------------------

Humanoid.Died:Connect(function()
	UnbindButtons()
end)

--------------------------------------------------------------------------------

UnbindButtons()