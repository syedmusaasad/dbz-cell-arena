--[[ SCRIPT ALLOWS FOR MELEE ]]--

local TORSO_HIT_ANIMATION_ID = 5580785255
local HEAD_HIT_ANIMATION_ID = 5580787535
local RIGHT_ARM_HIT_ANIMATION_ID = 5580792059
local LEFT_ARM_HIT_ANIMATION_ID = 5580797522
local RIGHT_LEG_HIT_ANIMATION_ID = 5580802654
local LEFT_LEG_HIT_ANIMATION_ID = 5580800225
local IMPACT_SOUND_ID = 1693499499
local AIR_SOUND_ID = 2235655773
local KILL_SOUND_ID = 441202925
local RIGHT_PUNCH_ANIMATION_ID
local LEFT_PUNCH_ANIMATION_ID
local RIGHT_KICK_ANIMATION_ID
local LEFT_KICK_ANIMATION_ID
local WIND_TIME = 0
local DEBOUNCE_TIME = 0.5
local WIND_SPEED = 12.5
local HIT_SPEED
local DAMAGE

--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

--------------------------------------------------------------------------------

local Tool = script.Parent
local Character
local Humanoid
local HumanoidRootPart
local CharacterDamage
local HitSpeed
local RightPunchAnimationId
local LeftPunchAnimationId
local RightKickAnimationId 
local LeftKickAnimationId
local Player
local Leaderstats
local Damage
local LocalDamage
local Kills
local LocalKills
local LoadedRightPunchAnimation
local LoadedLeftPunchAnimation
local LoadedRightKickAnimation
local LoadedLeftKickAnimation

--------------------------------------------------------------------------------

local Enabled = true

--------------------------------------------------------------------------------

-- Initialize values.

local AirSound = Instance.new("Sound", Tool)
AirSound.Name = "AirSound"
AirSound.EmitterSize = 5
AirSound.SoundId = "rbxassetid://"..AIR_SOUND_ID
AirSound.TimePosition = 0.25

local KillSound = Instance.new("Sound", Tool)
KillSound.Name = "KillSound"
KillSound.EmitterSize = 5
KillSound.SoundId = "rbxassetid://"..KILL_SOUND_ID

local ImpactSound = Instance.new("Sound", Tool)
ImpactSound.Name = "ImpactSound"
ImpactSound.EmitterSize = 5
ImpactSound.SoundId = "rbxassetid://"..IMPACT_SOUND_ID

local RightPunchAnimation = Instance.new("Animation", Tool)
RightPunchAnimation.Name = "RightPunchAnimation"

local LeftPunchAnimation = Instance.new("Animation", Tool)
LeftPunchAnimation.Name = "LeftPunchAnimation"

local RightKickAnimation = Instance.new("Animation", Tool)
RightKickAnimation.Name = "RightKickAnimation"

local LeftKickAnimation = Instance.new("Animation", Tool)
LeftKickAnimation.Name = "LeftKickAnimation"

local HeadHitAnimation = Instance.new("Animation", Tool)
HeadHitAnimation.Name = "HeadHitAnimation"
HeadHitAnimation.AnimationId = "rbxassetid://"..HEAD_HIT_ANIMATION_ID

local TorsoHitAnimation = Instance.new("Animation", Tool)
TorsoHitAnimation.Name = "TorsoHitAnimation"
TorsoHitAnimation.AnimationId = "rbxassetid://"..TORSO_HIT_ANIMATION_ID

local RightArmHitAnimation = Instance.new("Animation", Tool)
RightArmHitAnimation.Name = "RightArmHitAnimation"
RightArmHitAnimation.AnimationId = "rbxassetid://"..RIGHT_ARM_HIT_ANIMATION_ID

local LeftArmHitAnimation = Instance.new("Animation", Tool)
LeftArmHitAnimation.Name = "LeftArmHitAnimation"
LeftArmHitAnimation.AnimationId = "rbxassetid://"..LEFT_ARM_HIT_ANIMATION_ID

local RightLegHitAnimation = Instance.new("Animation", Tool)
RightLegHitAnimation.Name = "RightLegHitAnimation"
RightLegHitAnimation.AnimationId = "rbxassetid://"..RIGHT_LEG_HIT_ANIMATION_ID

local LeftLegHitAnimation = Instance.new("Animation", Tool)
LeftLegHitAnimation.Name = "LeftLegHitAnimation"
LeftLegHitAnimation.AnimationId = "rbxassetid://"..LEFT_LEG_HIT_ANIMATION_ID

--------------------------------------------------------------------------------

local function HitAnimation(BodyPart, TargetHumanoid)
	local LoadedHeadHitAnimation = TargetHumanoid:LoadAnimation(HeadHitAnimation)
	local LoadedTorsoHitAnimation = TargetHumanoid:LoadAnimation(TorsoHitAnimation)
	local LoadedRightArmHitAnimation = TargetHumanoid:LoadAnimation(RightArmHitAnimation)
	local LoadedLeftArmHitAnimation = TargetHumanoid:LoadAnimation(LeftArmHitAnimation)
	local LoadedRightLegHitAnimation = TargetHumanoid:LoadAnimation(RightLegHitAnimation)
	local LoadedLeftLegHitAnimation = TargetHumanoid:LoadAnimation(LeftLegHitAnimation)
	
	if BodyPart == "Head" then
		LoadedHeadHitAnimation:Play()
	elseif BodyPart == "Torso" or BodyPart == "HumanoidRootPart" then
		LoadedTorsoHitAnimation:Play()
	elseif BodyPart == "Right Arm" then
		LoadedRightArmHitAnimation:Play()
	elseif BodyPart == "Left Arm" then
		LoadedLeftLegHitAnimation:Play()
	elseif BodyPart == "Right Leg" then
		LoadedRightLegHitAnimation:Play()
	elseif BodyPart == "Left Leg" then
		LoadedLeftLegHitAnimation:Play()
	end
end

--------------------------------------------------------------------------------

local function CreateHitBox()
	
	-- Play air sound.

	AirSound:Play()
	
	-- Create wind hit box.
	
	local Wind = Instance.new("Part", Character)
	Wind.CastShadow = false
	Wind.Transparency = 1
	Wind.Name = "Wind"
	Wind.CanCollide = false
	Wind.Shape = Enum.PartType.Ball
	Wind.Size = Vector3.new(12, 12, 12)
	Wind.CFrame = (HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait())
	
	-- Make it go forward.
	
	local BodyVelocity = Instance.new("BodyVelocity", Wind)
	BodyVelocity.Velocity = (HumanoidRootPart.CFrame.LookVector or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():GetPropertyChangedSignal("LookVector"):Wait()) * WIND_SPEED
	BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	
	-- Make it do damage on touch and add to stats.
	
	local Debounce = false
	
	Wind.Touched:Connect(function(Part)
		local TargetCharacter = Part.Parent
		local TargetHumanoid = TargetCharacter:FindFirstChild("Humanoid")
		
		if not Debounce and TargetHumanoid and not TargetHumanoid:IsDescendantOf(Character) then
			Debounce = true
			
			---- See if a tag exists.
			local Dead = TargetHumanoid:FindFirstChild("Dead")
			
			if not Dead then
				if (TargetHumanoid.Health or TargetHumanoid:GetPropertyChangedSignal("Health"):Wait()) > 0 then
					
					----
					DAMAGE = CharacterDamage.Value or CharacterDamage:GetPropertyChangedSignal("Value"):Wait()
					
					----
					TargetHumanoid:TakeDamage(DAMAGE)
					
					---- Play impact sound.
					ImpactSound:Play()
					
					---- Play hit animation.
					local CoroutineHit = coroutine.create(HitAnimation)
					coroutine.resume(CoroutineHit, Part.Name or Part:GetPropertyChangedSignal("Name"):Wait(), TargetHumanoid)
					
					---- Add to damage stats.
					LocalDamage.Value += DAMAGE
					Damage.Value += DAMAGE
					
					----
					if (TargetHumanoid.Health or TargetHumanoid:GetPropertyChangedSignal("Health"):Wait()) <= 0 then
						------ Create a dead tag.
						local DeadTag = Instance.new("BoolValue", TargetHumanoid)
						DeadTag.Name = "Dead"
						------ Play death sound.
						KillSound:Play()
						------ Add to kill stats.
						LocalKills.Value += 1
						Kills.Value += 1
					end
				end
			end
			
			wait(DEBOUNCE_TIME)
			
			Debounce = false
			
		end
		
	end)
	
	HIT_SPEED = HitSpeed.Value or HitSpeed:GetPropertyChangedSignal("Value"):Wait()
	wait(HIT_SPEED)
	
	return Wind
end

--------------------------------------------------------------------------------

Tool.Equipped:Connect(function()
	-- Make sure below values are assigned correctly.
	
	Character = Tool.Parent
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	CharacterDamage = Character:WaitForChild("Damage")
	HitSpeed = Character:WaitForChild("HitSpeed")
	RightPunchAnimationId = Character:WaitForChild("RightPunchAnimationId")
	RIGHT_PUNCH_ANIMATION_ID = RightPunchAnimationId.Value or RightPunchAnimationId:GetPropertyChangedSignal("Value"):Wait()
	RightPunchAnimation.AnimationId = "rbxassetid://"..RIGHT_PUNCH_ANIMATION_ID
	LoadedRightPunchAnimation = Humanoid:LoadAnimation(RightPunchAnimation)
	LeftPunchAnimationId = Character:WaitForChild("LeftPunchAnimationId")
	LEFT_PUNCH_ANIMATION_ID = LeftPunchAnimationId.Value or LeftPunchAnimationId:GetPropertyChangedSignal("Value"):Wait()
	LeftPunchAnimation.AnimationId = "rbxassetid://"..LEFT_PUNCH_ANIMATION_ID
	LoadedLeftPunchAnimation = Humanoid:LoadAnimation(LeftPunchAnimation)
	RightKickAnimationId = Character:WaitForChild("RightKickAnimationId")
	RIGHT_KICK_ANIMATION_ID = RightKickAnimationId.Value or RightKickAnimationId:GetPropertyChangedSignal("Value"):Wait()
	RightKickAnimation.AnimationId = "rbxassetid://"..RIGHT_KICK_ANIMATION_ID
	LoadedRightKickAnimation = Humanoid:LoadAnimation(RightKickAnimation)
	LeftKickAnimationId = Character:WaitForChild("LeftKickAnimationId")
	LEFT_KICK_ANIMATION_ID = LeftKickAnimationId.Value or LeftKickAnimationId:GetPropertyChangedSignal("Value"):Wait()
	LeftKickAnimation.AnimationId = "rbxassetid://"..LEFT_KICK_ANIMATION_ID
	LoadedLeftKickAnimation = Humanoid:LoadAnimation(LeftKickAnimation)
	Player = Players:GetPlayerFromCharacter(Character)
	Leaderstats = Player:WaitForChild("leaderstats")
	Damage = Leaderstats:WaitForChild("Damage")
	LocalDamage = Player:WaitForChild("LocalDamage")
	Kills = Leaderstats:WaitForChild("Kills")
	LocalKills = Player:WaitForChild("LocalKills")
end)

--------------------------------------------------------------------------------

Tool.Activated:Connect(function()
	if Enabled then
		
		Enabled = false
		
		-- Get random number to choose move.
		
		---- Get random number.
		local OPTION = math.random(1, 4)
		local Wind
		
		---- Choose move.
		if OPTION == 1 then
			LoadedRightPunchAnimation:Play()
			Wind = CreateHitBox()
			LoadedRightPunchAnimation:Stop()
		elseif OPTION == 2 then
			LoadedLeftPunchAnimation:Play()
			Wind = CreateHitBox()
			LoadedLeftPunchAnimation:Stop()
		elseif OPTION == 3 then
			LoadedRightKickAnimation:Play()
			Wind = CreateHitBox()
			LoadedRightKickAnimation:Stop()
		elseif OPTION == 4 then
			LoadedLeftKickAnimation:Play()
			Wind = CreateHitBox()
			LoadedLeftKickAnimation:Stop()
		end
		
		--
		
		wait()
		
		--
		
		Enabled = true
		
		-- Destroy remnants.
		
		Debris:AddItem(Wind, WIND_TIME)
	end
end)