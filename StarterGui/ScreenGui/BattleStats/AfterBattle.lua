--[[ SCRIPT SHOWS BATTLE STATS ]]--

local NOTIFICATION_SOUND_ID = 523194796
local TIME_PRESENT = 7.5

--------------------------------------------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BattleStatsRemoteEvent = ReplicatedStorage:WaitForChild("BattleStatsRemoteEvent")

--------------------------------------------------------------------------------

local Frame = script.Parent
local KillsLabel = Frame:WaitForChild("KillsLabel")
local DamageLabel = Frame:WaitForChild("DamageLabel")
local YenLabel = Frame:WaitForChild("YenLabel")

--------------------------------------------------------------------------------

BattleStatsRemoteEvent.OnClientEvent:Connect(function(LOCAL_YEN, LOCAL_DAMAGE, LOCAL_KILLS)
	if LOCAL_YEN > 0 or LOCAL_DAMAGE > 0 or LOCAL_KILLS > 0 then
		Frame.Visible = true
		
		local NotificationSound = Instance.new("Sound", Frame)
		NotificationSound.Name = "Notification"
		NotificationSound.SoundId = "rbxassetid://"..NOTIFICATION_SOUND_ID
		NotificationSound:Play()
		
		YenLabel.Text = "YEN: " .. LOCAL_YEN
		DamageLabel.Text = "DAMAGE: " .. LOCAL_DAMAGE
		KillsLabel.Text = "KILLS: " .. LOCAL_KILLS
		
		wait(TIME_PRESENT)
		
		NotificationSound:Destroy()
		
		Frame.Visible = false
	end
end)