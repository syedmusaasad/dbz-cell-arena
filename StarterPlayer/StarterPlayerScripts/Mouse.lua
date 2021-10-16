--[[ SCRIPT GIVES MOUSE CFRAME TO PLAYER ]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MouseRemoteFunction = ReplicatedStorage:WaitForChild("MouseRemoteFunction")

--------------------------------------------------------------------------------

local PlayerScripts = script.Parent
local Player = PlayerScripts.Parent
local Mouse = Player:GetMouse()

--------------------------------------------------------------------------------

MouseRemoteFunction.OnClientInvoke = function()
	return Mouse.Hit or Mouse:GetPropertyChangedSignal("Hit"):Wait()
end