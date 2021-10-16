--[[ SCRIPT SAVES DATA ]]--

local WAIT_TIME = 15

--------------------------------------------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SaveRemoteEvent = ReplicatedStorage:WaitForChild("SaveRemoteEvent")

--------------------------------------------------------------------------------

local Button = script.Parent

--------------------------------------------------------------------------------

local Enabled = true

--------------------------------------------------------------------------------

Button.Activated:Connect(function()
	if Enabled then
		
		-- Saving information.
		
		Enabled = false
		Button.Text = "SAVING..."
		
		-- Save from server.
		
		SaveRemoteEvent:FireServer()
		
		-- Saved information.
		
		Button.Text = "SAVED"
		
		-- 
		
		wait(WAIT_TIME)
		
		-- Change values back.
		
		Enabled = true
		Button.Text = "SAVE"
	end
end)