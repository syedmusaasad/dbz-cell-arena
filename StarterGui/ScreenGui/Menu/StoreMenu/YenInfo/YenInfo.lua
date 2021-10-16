--[[ SCRIPT DISPLAYS DIFFERENT INFO WITH DIFFERENT MULTIPLIER ]]--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Multiplier = Player:WaitForChild("Multiplier")

--------------------------------------------------------------------------------

local Label = script.Parent

--------------------------------------------------------------------------------

function EditText()
	local MULTIPLIER = Multiplier.Value or Multiplier:GetPropertyChangedSignal("Value"):Wait()
	
	if MULTIPLIER > 1 then
		Label.Text = "2 YEN IS 500 DAMAGE OR 1 KILL"
	end
end

--------------------------------------------------------------------------------

Multiplier.Changed:Connect(function()
	EditText()
end)

--------------------------------------------------------------------------------

EditText()