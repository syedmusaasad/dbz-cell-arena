--[[ SCRIPT TRANSFORMS CHARACTER ]]--

local ANIMATION_ID = 5371383608
local POWER_UP_SOUND_ID = 4825612647
local POWER_DOWN_SOUND_ID = 769380905
local AURA_SOUND_ID = 952227583
local AURA_TEXTURE_ID = 1167543441
local LIGHTNING_TEXTURE_ID = 281983337
local TRANSFORMATION_TIME = 30
local COOLDOWN_TIME = 60
local TRANSFORMATION_TYPE

--------------------------------------------------------------------------------

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

--------------------------------------------------------------------------------

local Tool = script.Parent
local Character
local TransformationType
local Damage
local FlightSpeed
local HitSpeed
local Humanoid
local HumanoidRootPart
local Animation
local LoadedAnimation
local Aura
local Lightning

--------------------------------------------------------------------------------

local Transformation = false
local Cooldown = false

--------------------------------------------------------------------------------

-- Initialize values.

local PowerUpSound = Instance.new("Sound", Tool)
PowerUpSound.Name = "PowerUpSound"
PowerUpSound.EmitterSize = 5
PowerUpSound.SoundId = "rbxassetid://"..POWER_UP_SOUND_ID

local PowerDownSound = Instance.new("Sound", Tool)
PowerDownSound.Name = "PowerDownSound"
PowerDownSound.EmitterSize = 5
PowerDownSound.SoundId = "rbxassetid://"..POWER_DOWN_SOUND_ID

local AuraSound = Instance.new("Sound", Tool)
AuraSound.Name = "AuraSound"
AuraSound.EmitterSize = 5
AuraSound.SoundId = "rbxassetid://"..AURA_SOUND_ID
AuraSound.Looped = true
AuraSound.PlaybackSpeed = 0.25

--------------------------------------------------------------------------------

local function CooldownTimer()
	wait(TRANSFORMATION_TIME)
	
	-- Transform back.
	
	---- Set info to cooling.
	Transformation = false
	Cooldown = true
	Tool.Name = "Cooling..."
	
	---- Play sounds (and turn off aura sound).
	AuraSound:Stop()
	
	PowerDownSound:Play()
	
	---- Remove aura.
	Aura:Destroy()
	
	if TRANSFORMATION_TYPE == "SSJ2" or TRANSFORMATION_TYPE == "Super" then
		Lightning:Destroy()
	end
	
	---- Create energy burst.
	local EnergyBurst = Instance.new("Part", Character)
	EnergyBurst.Color = Color3.fromRGB(255, 255, 255) -- White.
	EnergyBurst.Material = Enum.Material.Neon
	EnergyBurst.Name = "EnergyBurst"
	EnergyBurst.Anchored = false
	EnergyBurst.CanCollide = false
	EnergyBurst.Size = Vector3.new(1, 1, 1)
	EnergyBurst.Shape = Enum.PartType.Ball
	EnergyBurst.CFrame = HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
	
	---- Attach it to body.
	local Weld = Instance.new("Weld", EnergyBurst)
	Weld.Part0 = EnergyBurst
	Weld.C0 = EnergyBurst.CFrame:Inverse() or EnergyBurst:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
	Weld.Part1 = HumanoidRootPart
	Weld.C1 = HumanoidRootPart.CFrame:Inverse() or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
	
	---- Make it grow in size.
	local EnergyBurstTweenInfo = TweenInfo.new(0.25)
	
	local EnergyBurstGoals = {
		Size = Vector3.new(7, 7, 7)
	}
	
	local EnergyBurstTween = TweenService:Create(EnergyBurst, EnergyBurstTweenInfo, EnergyBurstGoals)
	
	EnergyBurstTween:Play()
	
	---- Change properties of character.
	------ Hair.
	if TRANSFORMATION_TYPE == "SSJ" or TRANSFORMATION_TYPE == "SSJ2" then
		local Hat1 = Character:WaitForChild("Hat1")
		local Handle1 = Hat1:WaitForChild("Handle")
		local Hat2 = Character:WaitForChild("Hat2")
		local Handle2 = Hat2:WaitForChild("Handle")
		
		local Handle1TweenInfo = TweenInfo.new(0.03)
		
		local Handle1TweenGoals = {
			Transparency = 0
		}
		
		local Handle1Tween = TweenService:Create(Handle1, Handle1TweenInfo, Handle1TweenGoals)
		
		Handle1Tween:Play()
		
		local Handle2TweenInfo = TweenInfo.new(0.03)
		
		local Handle2TweenGoals = {
			Transparency = 1
		}
		
		local Handle2Tween = TweenService:Create(Handle2, Handle2TweenInfo, Handle2TweenGoals)
		
		Handle2Tween:Play()
	end
	------ Attributes.
	Humanoid.WalkSpeed /= 1.5
	Humanoid.JumpPower /= 1.5
	Damage.Value /= 1.5
	FlightSpeed.Value /= 1.5
	HitSpeed.Value += 0.15
	
	---- Destroy energy burst.
	Debris:AddItem(EnergyBurst, 0.25)
	
	--
	
	wait(COOLDOWN_TIME)
	
	---- Set info to ready.
	Cooldown = false
	Tool.Name = TRANSFORMATION_TYPE
end

--------------------------------------------------------------------------------

Tool.Equipped:Connect(function()
	-- Make sure below values are assigned correctly.
	
	Character = Tool.Parent
	Damage = Character:WaitForChild("Damage")
	FlightSpeed = Character:WaitForChild("FlightSpeed")
	HitSpeed = Character:WaitForChild("HitSpeed")
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	TransformationType = Character:WaitForChild("TransformationType")
	TRANSFORMATION_TYPE = TransformationType.Value or TransformationType:GetPropertyChangedSignal("Value"):Wait()
end)

--------------------------------------------------------------------------------

Tool.Activated:Connect(function()
	if not Transformation and not Cooldown then
		-- Begin cooldown.
		
		local CoroutineCooldown = coroutine.create(CooldownTimer)
		coroutine.resume(CoroutineCooldown)
		
		-- Tranform.
		
		---- Set info to transformed.
		Transformation = true
		Tool.Name = "Transformed"
		
		---- Play animation.
		Animation = Instance.new("Animation", Tool)
		Animation.AnimationId = "rbxassetid://"..ANIMATION_ID
		
		LoadedAnimation = Humanoid:LoadAnimation(Animation)
		LoadedAnimation:Play()
		
		---- Play sounds.
		
		PowerUpSound:Play()
		AuraSound:Play()
		
		---- Create energy burst.
		local EnergyBurst = Instance.new("Part", Character)
		if TRANSFORMATION_TYPE == "SSJ" or TRANSFORMATION_TYPE == "SSJ2" or TRANSFORMATION_TYPE == "Super" then
			EnergyBurst.Color = Color3.fromRGB(255, 255, 0) -- Yellow.
		else
			EnergyBurst.Color = Color3.fromRGB(255, 255, 255) -- White.
		end
		EnergyBurst.Material = Enum.Material.Neon
		EnergyBurst.Name = "EnergyBurst"
		EnergyBurst.Anchored = false
		EnergyBurst.CanCollide = false
		EnergyBurst.Size = Vector3.new(1, 1, 1)
		EnergyBurst.Shape = Enum.PartType.Ball
		EnergyBurst.CFrame = HumanoidRootPart.CFrame or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
		
		---- Attach it to body.
		local Weld = Instance.new("Weld", EnergyBurst)
		Weld.Part0 = EnergyBurst
		Weld.C0 = EnergyBurst.CFrame:Inverse() or EnergyBurst:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		Weld.Part1 = HumanoidRootPart
		Weld.C1 = HumanoidRootPart.CFrame:Inverse() or HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait():Inverse()
		
		---- Make it grow in size.
		local EnergyBurstTweenInfo = TweenInfo.new(0.25)
		
		local EnergyBurstGoals = {
			Size = Vector3.new(7, 7, 7)
		}
		
		local EnergyBurstTween = TweenService:Create(EnergyBurst, EnergyBurstTweenInfo, EnergyBurstGoals)
		
		EnergyBurstTween:Play()
		
		---- Change properties of character.
		------ Hair.
		if TRANSFORMATION_TYPE == "SSJ" or TRANSFORMATION_TYPE == "SSJ2" then
			local Hat1 = Character:WaitForChild("Hat1")
			local Handle1 = Hat1:WaitForChild("Handle")
			local Hat2 = Character:WaitForChild("Hat2")
			local Handle2 = Hat2:WaitForChild("Handle")
			
			local Handle1TweenInfo = TweenInfo.new(0.03)
			
			local Handle1TweenGoals = {
				Transparency = 1
			}
			
			local Handle1Tween = TweenService:Create(Handle1, Handle1TweenInfo, Handle1TweenGoals)
			
			Handle1Tween:Play()
			
			local Handle2TweenInfo = TweenInfo.new(0.03)
			
			local Handle2TweenGoals = {
				Transparency = 0
			}
			
			local Handle2Tween = TweenService:Create(Handle2, Handle2TweenInfo, Handle2TweenGoals)
			
			Handle2Tween:Play()
		end
		------ Aura.
		Aura = Instance.new("ParticleEmitter", HumanoidRootPart)
		Aura.Name = "Aura"
		Aura.LightEmission = 0.65
		Aura.LightInfluence = 0
		Aura.Texture = "rbxassetid://"..AURA_TEXTURE_ID
		Aura.Transparency = NumberSequence.new(0.95)
		Aura.ZOffset = -0.6
		Aura.LockedToPart = true
		Aura.Lifetime = NumberRange.new(1.05)
		Aura.Rotation = NumberRange.new(-15, 15)
		Aura.RotSpeed = NumberRange.new(-5, 5)
		Aura.Size = NumberSequence.new(5)
		Aura.Speed = NumberRange.new(1)
		Aura.SpreadAngle = Vector2.new(10000, 10000)
		if TRANSFORMATION_TYPE == "SSJ" or TRANSFORMATION_TYPE == "SSJ2" or TRANSFORMATION_TYPE == "Super" then
			Aura.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0)) -- Yellow.
		else
			Aura.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)) -- White.
		end
		------ Lightning.
		if TRANSFORMATION_TYPE == "SSJ2" or TRANSFORMATION_TYPE == "Super" then
			Lightning = Instance.new("ParticleEmitter", HumanoidRootPart)
			Lightning.Name = "Lightning"
			Lightning.LightEmission = 1
			Lightning.LightInfluence = 0
			Lightning.Size = NumberSequence.new(2.2)
			Lightning.Texture = "rbxassetid://"..LIGHTNING_TEXTURE_ID
			Lightning.ZOffset = 1
			Lightning.EmissionDirection = Enum.NormalId.Right
			Lightning.Lifetime = NumberRange.new(0.09)
			Lightning.Rate = 1.5
			Lightning.Rotation = NumberRange.new(45, 160)
			Lightning.Speed = NumberRange.new(0.2)
		end
		------ Attributes.
		Humanoid.WalkSpeed *= 1.5
		Humanoid.JumpPower *= 1.5
		Damage.Value *= 1.5
		FlightSpeed.Value *= 1.5
		HitSpeed.Value -= 0.15
		
		---- Destroy energy burst.
		Debris:AddItem(EnergyBurst, 0.25)
	end
end)
