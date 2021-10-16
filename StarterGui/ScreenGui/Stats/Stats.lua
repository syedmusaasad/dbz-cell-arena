--[[ SCRIPT SHOWS STATS ]]--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Leaderstats = Player:WaitForChild("leaderstats")
local Kills = Leaderstats:WaitForChild("Kills")
local Damage = Leaderstats:WaitForChild("Damage")
local Yen = Leaderstats:WaitForChild("Yen")

--------------------------------------------------------------------------------

local Frame = script.Parent
local KillsLabel = Frame:WaitForChild("KillsLabel")
local DamageLabel = Frame:WaitForChild("DamageLabel")
local YenLabel = Frame:WaitForChild("YenLabel")

--------------------------------------------------------------------------------

KillsLabel.Text = "KILLS: "..Kills.Value or Kills:GetPropertyChangedSignal("Value"):Wait()
DamageLabel.Text = "DAMAGE: "..Damage.Value or Damage:GetPropertyChangedSignal("Value"):Wait()
YenLabel.Text = "YEN: "..Yen.Value or Yen:GetPropertyChangedSignal("Value"):Wait()

--------------------------------------------------------------------------------

Kills.Changed:Connect(function()
	KillsLabel.Text = "KILLS: "..Kills.Value or Kills:GetPropertyChangedSignal("Value"):Wait()
end)

--------------------------------------------------------------------------------

Damage.Changed:Connect(function()
	DamageLabel.Text = "DAMAGE: "..Damage.Value or Damage:GetPropertyChangedSignal("Value"):Wait()
end)

--------------------------------------------------------------------------------

Yen.Changed:Connect(function()
	YenLabel.Text = "YEN: "..Yen.Value or Yen:GetPropertyChangedSignal("Value"):Wait()
end)