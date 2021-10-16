--[[ SCRIPT CREATES KI BEAM ]]--

local TORSO_HIT_ANIMATION_ID = 5580785255
local HEAD_HIT_ANIMATION_ID = 5580787535
local RIGHT_ARM_HIT_ANIMATION_ID = 5580792059
local LEFT_ARM_HIT_ANIMATION_ID = 5580797522
local RIGHT_LEG_HIT_ANIMATION_ID = 5580802654
local LEFT_LEG_HIT_ANIMATION_ID = 5580800225
local LIGHTNING_TEXTURE_ID = 281983337
local CHARGING_ANIMATION_ID = 5591988738
local BLASTING_ANIMATION_ID = 5591672614
local CHARGING_SOUND_ID = 1370232812
local BLASTING_SOUND_ID = 5127324195
local BLAST_TIME = 2
local COOLDOWN_TIME = 7.5
local TWEEN_TIME = 2
local DEBOUNCE_TIME = 0.25
local ENABLE_TIME = 0.25
local RING_TIME = 0.03
local KI_COLOR
local DAMAGE
local TOOL_NAME

--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local DestroyScript = ServerStorage:WaitForChild("DestroyScript")
local DestroyTagScript = ServerStorage:WaitForChild("DestroyTagScript")
local StoredRing = ServerStorage:WaitForChild("Ring")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MouseRemoteFunction = ReplicatedStorage:WaitForChild("MouseRemoteFunction")

--------------------------------------------------------------------------------

local Tool = script.Parent
local Character
local CharacterDamage
local ToolName
local KiBlastColor
local FlightSpeed
local Humanoid
local LoadedChargingAnimation
local LoadedBlastingAnimation
local HumanoidRootPart
local Player
local Leaderstats
local Damage
local LocalDamage
local Kills
local LocalKills
local OuterChargingBall

--------------------------------------------------------------------------------

local Free = true
local Cooldown = false

--------------------------------------------------------------------------------

-- Initalize values.

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

local ChargingAnimation = Instance.new("Animation", Tool)
ChargingAnimation.Name = "ChargingAnimation"
ChargingAnimation.AnimationId = "rbxassetid://"..CHARGING_ANIMATION_ID

local BlastingAnimation = Instance.new("Animation", Tool)
BlastingAnimation.Name = "BlastingAnimation"
BlastingAnimation.AnimationId = "rbxassetid://"..BLASTING_ANIMATION_ID

local ChargingSound = Instance.new("Sound", Tool)
ChargingSound.Name = "ChargingSound"
ChargingSound.TimePosition = 0
ChargingSound.EmitterSize = 5
ChargingSound.SoundId = "rbxassetid://"..CHARGING_SOUND_ID

local BlastingSound = Instance.new("Sound", Tool)
BlastingSound.Name = "BlastingSound"
BlastingSound.TimePosition = 6.5
BlastingSound.EmitterSize = 5
BlastingSound.SoundId = "rbxassetid://"..BLASTING_SOUND_ID

local Lightning = Instance.new("ParticleEmitter", HumanoidRootPart)
Lightning.Name = "Lightning"
Lightning.LightEmission = 1
Lightning.LightInfluence = 0
Lightning.Size = NumberSequence.new(1)
Lightning.Texture = "rbxassetid://"..LIGHTNING_TEXTURE_ID
Lightning.ZOffset = 1
Lightning.EmissionDirection = Enum.NormalId.Right
Lightning.Lifetime = NumberRange.new(0.09)
Lightning.Rate = 1.5
Lightning.Rotation = NumberRange.new(45, 160)
Lightning.Speed = NumberRange.new(0.2)

--------------------------------------------------------------------------------

local function CreateRing(Parent)
	local HUMANOID_CFRAME = HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
	local HUMANOID_LOOK_VECTOR = HUMANOID_CFRAME.LookVector or HUMANOID_CFRAME:GetPropertyChangedSignal("LookVector"):Wait()
	for Incrementation = 5, 125, 3 do
		local Ring = StoredRing:Clone()
		Ring.Parent = Parent
		Ring.CFrame = (CFrame.new(HUMANOID_LOOK_VECTOR * Incrementation) * HUMANOID_CFRAME) * CFrame.Angles(math.rad(90), 0, 0)
		Ring.Anchored = true
		wait(RING_TIME)
	end
end

--------------------------------------------------------------------------------

local function CreateDamagingTag(TargetHumanoid)
	local TargetCharacter = TargetHumanoid.Parent
	local FlightSpeed = TargetCharacter:FindFirstChild("FlightSpeed")
	local DamagingTag = Instance.new("BoolValue", TargetHumanoid)
	local DestroyTagScriptClone = DestroyTagScript:Clone()
	
	DamagingTag.Name = "Damaging"..Player.UserId
	DestroyTagScriptClone.Parent = DamagingTag
	TargetHumanoid.WalkSpeed /= 4
	if FlightSpeed then
		FlightSpeed.Value /= 4
	end
end

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

local function Attack(Part, TargetCharacter, TargetHumanoid)
	local TargetCharacter = Part.Parent
	local TargetHumanoid = TargetCharacter:FindFirstChild("Humanoid")
	
	if TargetHumanoid and not TargetHumanoid:IsDescendantOf(Character) then
		
		---- See if a tag exists.
		local Dead = TargetHumanoid:FindFirstChild("Dead")
		local Damaging = TargetHumanoid:FindFirstChild("Damaging"..Player.UserId)
		
		if not Dead and not Damaging then
			if (TargetHumanoid.Health or TargetHumanoid:GetPropertyChangedSignal("Health"):Wait()) > 0 then
				
				----
				DAMAGE = (CharacterDamage.Value or CharacterDamage:GetPropertyChangedSignal("Value"):Wait())
				
				----
				TargetHumanoid:TakeDamage(DAMAGE)
				
				---- Play hit animation.
				local CoroutineHit = coroutine.create(HitAnimation)
				coroutine.resume(CoroutineHit, Part.Name or Part:GetPropertyChangedSignal("Name"):Wait(), TargetHumanoid)
				
				---- Create a damaging tag, then destroy it after a few seconds.
				local CoroutineDamaging = coroutine.create(CreateDamagingTag)
				coroutine.resume(CoroutineDamaging, TargetHumanoid)
				
				---- Add to damage stats.
				LocalDamage.Value += DAMAGE
				Damage.Value += DAMAGE
				
				----
				if (TargetHumanoid.Health or TargetHumanoid:GetPropertyChangedSignal("Health"):Wait()) <= 0 then
					------ Create a dead tag.
					local DeadTag = Instance.new("BoolValue", TargetHumanoid)
					DeadTag.Name = "Dead"
					------ Add to kill stats.
					LocalKills.Value += 1
					Kills.Value += 1
				end
			end
		end
		
	end
end

--------------------------------------------------------------------------------

local function ClearRemnants()
	if OuterChargingBall then
		OuterChargingBall:Destroy()
		OuterChargingBall = nil
	end
end

--------------------------------------------------------------------------------

local function CooldownTimer()
	Cooldown = true
	Tool.Name = "Charging..."
	wait(COOLDOWN_TIME)
	Cooldown = false
	Tool.Name = TOOL_NAME
end

--------------------------------------------------------------------------------

Tool.Equipped:Connect(function()
	
	-- Make sure below values are assigned correctly.
	
	Character = Tool.Parent
	CharacterDamage = Character:WaitForChild("Damage")
	ToolName = Character:WaitForChild("KiBlastName")
	TOOL_NAME = ToolName.Value or ToolName:GetPropertyChangedSignal("Value"):Wait()
	KiBlastColor = Character:WaitForChild("KiBlastColor")
	KI_COLOR = KiBlastColor.Value or KiBlastColor:GetPropertyChangedSignal("Value"):Wait()
	FlightSpeed = Character:WaitForChild("FlightSpeed")
	Humanoid = Character:WaitForChild("Humanoid")
	LoadedChargingAnimation = Humanoid:LoadAnimation(ChargingAnimation)
	LoadedBlastingAnimation = Humanoid:LoadAnimation(BlastingAnimation)
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	Player = Players:GetPlayerFromCharacter(Character)
	Leaderstats = Player:WaitForChild("leaderstats")
	Damage = Leaderstats:WaitForChild("Damage")
	LocalDamage = Player:WaitForChild("LocalDamage")
	Kills = Leaderstats:WaitForChild("Kills")
	LocalKills = Player:WaitForChild("LocalKills")
	
	-- Incase character dies while charging, destroy the ball.
	
	Humanoid.Died:Connect(function()
		ClearRemnants()
	end)
end)

--------------------------------------------------------------------------------

Tool.Activated:Connect(function()
	if Free and not Cooldown then
		Free = false
		
		ClearRemnants()
		
		-- Make character charge up Kamehameha.	
		
		---- Play animation and loop charging sound.
		LoadedChargingAnimation:Play()
		ChargingSound:Play()
		
		---- Slow player down.
		Humanoid.WalkSpeed /= 2
		Humanoid.JumpPower /= 2
		FlightSpeed.Value /= 2
		
		---- Create outer ball.
		OuterChargingBall = Instance.new("Part", workspace)
		OuterChargingBall.Color = KI_COLOR
		OuterChargingBall.Material = Enum.Material.Neon               
		OuterChargingBall.Transparency = 0.5                          
		OuterChargingBall.Name = "OuterChargingBall"                
		OuterChargingBall.CanCollide = false                          
		OuterChargingBall.Shape = Enum.PartType.Ball                  
		OuterChargingBall.Size = Vector3.new(1, 1, 1)
		local HUMANOID_CFRAME = HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
		local HUMANOID_LOOK_VECTOR = HUMANOID_CFRAME.LookVector or HUMANOID_CFRAME:GetPropertyChangedSignal("LookVector"):Wait()
		local HUMANOID_UP_VECTOR = HUMANOID_CFRAME.UpVector or HUMANOID_CFRAME:GetPropertyChangedSignal("UpVector"):Wait()
		OuterChargingBall.CFrame = CFrame.new((HUMANOID_UP_VECTOR * 1.5) + HUMANOID_LOOK_VECTOR) * HUMANOID_CFRAME
		
		local LightningEmission = Lightning:Clone()
		LightningEmission.Enabled = true
		LightningEmission.Parent = OuterChargingBall
		
		local OuterChargingBallWeld = Instance.new("Weld", OuterChargingBall)
		OuterChargingBallWeld.Part0 = OuterChargingBall
		OuterChargingBallWeld.C0 = OuterChargingBall.CFrame:Inverse() or OuterChargingBall:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		OuterChargingBallWeld.Part1 = HumanoidRootPart
		OuterChargingBallWeld.C1 = HumanoidRootPart.CFrame:Inverse() or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		
		local OuterChargingBallTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true)
		
		local OuterChargingBallTweenGoals = {
			Size = Vector3.new(1.5, 1.5, 1.5)
		}
		
		local OuterChargingBallTween = TweenService:Create(OuterChargingBall, OuterChargingBallTweenInfo, OuterChargingBallTweenGoals)
		
		OuterChargingBallTween:Play()
		
		---- Create inner ball.
		local InnerChargingBall = Instance.new("Part", OuterChargingBall)
		InnerChargingBall.Color = Color3.fromRGB(255, 255, 0) -- Yellow.
		InnerChargingBall.Material = Enum.Material.Neon
		InnerChargingBall.Name = "InnerChargingBall"
		InnerChargingBall.CanCollide = false
		InnerChargingBall.Shape = Enum.PartType.Ball
		InnerChargingBall.Size = Vector3.new((2/(3/2))/2, (2/(3/2))/2, (2/(3/2))/2)
		InnerChargingBall.CFrame = OuterChargingBall.CFrame or OuterChargingBall:GetPropertyChangedSignal("CFrame"):Wait()
		
		local InnerChargingBallWeld = Instance.new("Weld", InnerChargingBall)
		InnerChargingBallWeld.Part0 = InnerChargingBall
		InnerChargingBallWeld.C0 = InnerChargingBall.CFrame:Inverse() or InnerChargingBall:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		InnerChargingBallWeld.Part1 = OuterChargingBall
		InnerChargingBallWeld.C1 = OuterChargingBall.CFrame:Inverse() or OuterChargingBall:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		
		local InnerChargingBallTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true)
		
		local InnerChargingBallTweenGoals = {
			Size = Vector3.new(1, 1, 1)
		}
		
		local InnerChargingBallTween = TweenService:Create(InnerChargingBall, InnerChargingBallTweenInfo, InnerChargingBallTweenGoals)
		
		InnerChargingBallTween:Play()
	end
end)

--------------------------------------------------------------------------------

Tool.Deactivated:Connect(function()
	Free = true
	
	if OuterChargingBall then
		
		-- Run cooldown.
		
		local CoroutineCooldown = coroutine.create(CooldownTimer)
		coroutine.resume(CoroutineCooldown)
		
		--
		
		ClearRemnants()
		
		-- Make character look at mouse when let go.
		
		---- Play animation and sound (and stop previous animation and sounds).
		LoadedChargingAnimation:Stop()
		ChargingSound:Stop()
		LoadedBlastingAnimation:Play()
		BlastingSound:Play()
		
		---- Change direction.
		local CurrentMouseHit = MouseRemoteFunction:InvokeClient(Player)
		HumanoidRootPart.Anchored = true
		HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.CFrame.Position or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():GetPropertyChangedSignal("Position"):Wait(), (HumanoidRootPart.CFrame.Position or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():GetPropertyChangedSignal("Position"):Wait()) + (CurrentMouseHit.LookVector or CurrentMouseHit:GetPropertyChangedSignal("LookVector"):Wait()))
		
		-- Make character blast Beam.
		
		---- Create first ball.
		
		------ Create outer ball.
		local SecondaryOuterChargingBall = Instance.new("Part", workspace)   
		local DestroySecondaryOuterChargingBallScript = DestroyScript:Clone()
		DestroySecondaryOuterChargingBallScript.Parent = SecondaryOuterChargingBall
		SecondaryOuterChargingBall.Anchored = true
		SecondaryOuterChargingBall.Color = KI_COLOR -- Yellow.
		SecondaryOuterChargingBall.Material = Enum.Material.Neon               
		SecondaryOuterChargingBall.Transparency = 0.5                          
		SecondaryOuterChargingBall.Name = "SecondaryOuterChargingBall"                
		SecondaryOuterChargingBall.CanCollide = false                          
		SecondaryOuterChargingBall.Shape = Enum.PartType.Ball                  
		SecondaryOuterChargingBall.Size = Vector3.new(6, 6, 6)
		local HUMANOID_CFRAME = HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
		local HUMANOID_LOOK_VECTOR = HUMANOID_CFRAME.LookVector or HUMANOID_CFRAME:GetPropertyChangedSignal("LookVector"):Wait()
		SecondaryOuterChargingBall.CFrame = CFrame.new(HUMANOID_LOOK_VECTOR * 3) * HUMANOID_CFRAME
		------ Create inner ball.
		local SecondaryInnerChargingBall = Instance.new("Part", SecondaryOuterChargingBall)
		SecondaryInnerChargingBall.Color = Color3.fromRGB(255, 255, 0) -- Yellow.
		SecondaryInnerChargingBall.Material = Enum.Material.Neon
		SecondaryInnerChargingBall.Name = "SecondaryInnerChargingBall"
		SecondaryInnerChargingBall.CanCollide = false
		SecondaryInnerChargingBall.Shape = Enum.PartType.Ball
		SecondaryInnerChargingBall.Size = Vector3.new(4, 4, 4)
		SecondaryInnerChargingBall.CFrame = SecondaryOuterChargingBall.CFrame or SecondaryOuterChargingBall:GetPropertyChangedSignal("CFrame"):Wait()
		
		local SecondaryInnerChargingBallWeld = Instance.new("Weld", SecondaryInnerChargingBall)
		SecondaryInnerChargingBallWeld.Part0 = SecondaryInnerChargingBall
		SecondaryInnerChargingBallWeld.C0 = SecondaryInnerChargingBall.CFrame:Inverse() or SecondaryInnerChargingBall:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		SecondaryInnerChargingBallWeld.Part1 = SecondaryOuterChargingBall
		SecondaryInnerChargingBallWeld.C1 = SecondaryOuterChargingBall.CFrame:Inverse() or SecondaryOuterChargingBall:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		
		---- Create beam.
		
		------ Create outer beam.
		local OuterBeam = Instance.new("Part", workspace)  
		local DestroyOuterBeamScript = DestroyScript:Clone()
		DestroyOuterBeamScript.Parent = OuterBeam
		local OuterBeamVelocity = Instance.new("BodyVelocity", OuterBeam)
		OuterBeamVelocity.Velocity = Vector3.new(0, 0, 0)
		OuterBeamVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		OuterBeam.Color = KI_COLOR -- Yellow.
		OuterBeam.Material = Enum.Material.Neon               
		OuterBeam.Transparency = 0.5                          
		OuterBeam.Name = "OuterBeam"                
		OuterBeam.CanCollide = false                          
		OuterBeam.Shape = Enum.PartType.Cylinder                  
		OuterBeam.Size = Vector3.new(0.3, 3, 3)
		local HUMANOID_CFRAME = HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
		local HUMANOID_LOOK_VECTOR = HUMANOID_CFRAME.LookVector or HUMANOID_CFRAME:GetPropertyChangedSignal("LookVector"):Wait()
		OuterBeam.CFrame = (CFrame.new(HUMANOID_LOOK_VECTOR * 5) * HUMANOID_CFRAME) * CFrame.Angles(0, math.rad(90), 0)
		
		local OuterBeamTweenInfo = TweenInfo.new(TWEEN_TIME)
		
		local OuterBeamTweenGoals = {
			Size = Vector3.new(120, 3, 3),
			CFrame = OuterBeam.CFrame * CFrame.new(60, 0, 0)
		}
		
		local OuterBeamTween = TweenService:Create(OuterBeam, OuterBeamTweenInfo, OuterBeamTweenGoals)
		
		OuterBeamTween:Play()
		------ Create inner beam.
		local InnerBeam = Instance.new("Part", OuterBeam)
		InnerBeam.Color = Color3.fromRGB(255, 255, 0) -- Yellow.
		InnerBeam.Material = Enum.Material.Neon
		InnerBeam.Name = "InnerBeam"
		InnerBeam.CanCollide = false
		InnerBeam.Shape = Enum.PartType.Cylinder
		InnerBeam.Size = Vector3.new(0.3, 2, 2)
		InnerBeam.CFrame = OuterBeam.CFrame or OuterBeam:GetPropertyChangedSignal("CFrame"):Wait()
		
		local InnerBeamWeld = Instance.new("Weld", InnerBeam)
		InnerBeamWeld.Part0 = InnerBeam
		InnerBeamWeld.C0 = InnerBeam.CFrame:Inverse() or InnerBeam:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		InnerBeamWeld.Part1 = OuterBeam
		InnerBeamWeld.C1 = OuterBeam.CFrame:Inverse() or OuterBeam:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		
		local InnerBeamTweenInfo = TweenInfo.new(TWEEN_TIME)
		
		local InnerBeamTweenGoals = {
			Size = Vector3.new(120, 2, 2),
			CFrame = InnerBeam.CFrame * CFrame.new(60, 0, 0)
		}
		
		local InnerBeamTween = TweenService:Create(InnerBeam, InnerBeamTweenInfo, InnerBeamTweenGoals)
		
		InnerBeamTween:Play()
		
		---- Create the rings.
		
		local CoroutineRing = coroutine.create(CreateRing)
		coroutine.resume(CoroutineRing, OuterBeam)
		
		---- Make the blast do damage.
		
		OuterBeam.Touched:Connect(function(Part)
			local TargetCharacter = Part.Parent
			local TargetHumanoid = TargetCharacter:FindFirstChild("Humanoid")
			Attack(Part, TargetCharacter, TargetHumanoid)
		end)
		
		wait(BLAST_TIME)
		
		-- Make character go back to normal.
		
		Humanoid.WalkSpeed *= 2
		Humanoid.JumpPower *= 2
		FlightSpeed.Value *= 2
		LoadedBlastingAnimation:Stop()
		HumanoidRootPart.Anchored = false
		HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.CFrame.Position or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():GetPropertyChangedSignal("Position"):Wait())
	end
end)

--------------------------------------------------------------------------------

Tool.Unequipped:Connect(function()
	
	-- Clear up ongoing processes.
	
	if not Free then
		Humanoid.WalkSpeed *= 2
		Humanoid.JumpPower *= 2
		FlightSpeed.Value *= 2
	end
	
	Free = true
	
	LoadedChargingAnimation:Stop()
	ChargingSound:Stop()
	ClearRemnants()
end)