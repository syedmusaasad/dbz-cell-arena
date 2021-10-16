--[[ SCRIPT PLAYS SOUNDTRACK ]]--

local SOUNDTRACK_ID = 1330648480

--------------------------------------------------------------------------------

local PlayerGui = script.Parent

--------------------------------------------------------------------------------

local Soundtrack = Instance.new("Sound", PlayerGui)
Soundtrack.Name = "Soundtrack"
Soundtrack.SoundId = "rbxassetid://"..SOUNDTRACK_ID
Soundtrack.Looped = true
Soundtrack:Play()