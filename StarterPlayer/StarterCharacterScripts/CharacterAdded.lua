--[[ SCRIPT GIVES CHARACTER SPAWN CHARACTERISTICS ]]--

local MULTIPLIER
local LOCAL_KILLS
local LOCAL_DAMAGE
local LOCAL_YEN
local DAMAGE_DIVIDER = 500

--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BattleStatsRemoteEvent = ReplicatedStorage:WaitForChild("BattleStatsRemoteEvent")

--------------------------------------------------------------------------------

local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")
local Player = Players:GetPlayerFromCharacter(Character)
local Leaderstats = Player:WaitForChild("leaderstats")
local Yen = Leaderstats:WaitForChild("Yen")
local LocalKills = Player:WaitForChild("LocalKills")
local LocalDamage = Player:WaitForChild("LocalDamage")
local Multiplier = Player:WaitForChild("Multiplier")

--------------------------------------------------------------------------------

local ForceField = Instance.new("ForceField", Character) -- Replace disappearing forcefield with stable one.

--------------------------------------------------------------------------------

-- Initialize values.

MULTIPLIER = Multiplier.Value or Multiplier:GetPropertyChangedSignal("Value"):Wait()
LOCAL_KILLS = LocalKills.Value or LocalKills:GetPropertyChangedSignal("Value"):Wait()
LOCAL_DAMAGE = LocalDamage.Value or LocalDamage:GetPropertyChangedSignal("Value"):Wait()
LOCAL_YEN = math.floor((LOCAL_KILLS + (LOCAL_DAMAGE / DAMAGE_DIVIDER)) * MULTIPLIER)

--------------------------------------------------------------------------------

-- Send values to client for battle stats display.

BattleStatsRemoteEvent:FireClient(Player, LOCAL_YEN, LOCAL_DAMAGE, LOCAL_KILLS)

-- Assign and reset local values.

Yen.Value += LOCAL_YEN
LocalKills.Value = 0
LocalDamage.Value = 0
