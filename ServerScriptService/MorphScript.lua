--[[ SCRIPT PUTS CHARACTER IN BATTLE WITH CHOSEN UNIT ]]--

local WAIT_TIME = 1
local ANIME_RUN_ID = 5128126003
local SOUNDTRACK_ID = 245830687

--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Mesh = ServerStorage:WaitForChild("Mesh")
local CharacterPack = ServerStorage:WaitForChild("CharacterPack")
local HttpService = game:GetService("HttpService")
local Lobby = workspace:WaitForChild("Lobby")
local CharacterSelection = Lobby:WaitForChild("CharacterSelection")

--------------------------------------------------------------------------------

local Debounce = false

--------------------------------------------------------------------------------

-- Set up each morph.

for _, MorphModel in pairs (CharacterSelection:GetChildren()) do
	local Enabled = true

	local Morph = MorphModel:WaitForChild("Morph")
	local MainMorphCharacter = MorphModel:WaitForChild("MorphCharacter")
	
	local NAME = MorphModel.Name or MorphModel:GetPropertyChangedSignal("Name"):Wait()
	local YEN = MainMorphCharacter:WaitForChild("YenCost").Value or MainMorphCharacter:WaitForChild("YenCost"):GetPropertyChangedSignal("Value"):Wait()
	
	
	---- When touched plate then take money, change character, and send to arena.
	Morph.Touched:Connect(function(Part)
		local Character = Part.Parent
		local Humanoid = Character:FindFirstChild("Humanoid")
		
		if Humanoid then
			local Player = Players:GetPlayerFromCharacter(Character)
			local PlayerGui = Player:WaitForChild("PlayerGui")
			local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
			local Stats = ScreenGui:WaitForChild("Stats")
			local CurrentMap = ScreenGui:WaitForChild("CurrentMap")
			local OwnedCellSagaPlayers = Player:WaitForChild("OwnedCellSagaPlayers")
			local CellSagaPlayerUses = Player:WaitForChild("CellSagaPlayerUses")
			local Leaderstats = Player:WaitForChild("leaderstats")
			local Yen = Leaderstats:WaitForChild("Yen")
			
			local PLAYER_YEN = Yen.Value or Yen:GetPropertyChangedSignal("Value"):Wait()
			local OWNED_CELL_SAGA_ENCODED = OwnedCellSagaPlayers.Value or OwnedCellSagaPlayers:GetPropertyChangedSignal("Value"):Wait()
			local OWNED_CELL_SAGA = HttpService:JSONDecode(OWNED_CELL_SAGA_ENCODED)
			local USES_CELL_SAGA_ENCODED = CellSagaPlayerUses.Value or CellSagaPlayerUses:GetPropertyChangedSignal("Value"):Wait()
			local USES_CELL_SAGA = HttpService:JSONDecode(USES_CELL_SAGA_ENCODED)
			
			if Enabled and not Debounce and CurrentMap.Text == "LOBBY (SPAWN)" then
				
				if OWNED_CELL_SAGA[NAME] then
					local MorphCharacter = MorphModel:WaitForChild("MorphCharacter"):Clone()
					local Health = CharacterPack:WaitForChild("Health"):Clone()
					local MeleeMove = CharacterPack:WaitForChild("MeleeMove"):Clone()
					local MeleeMoveScript = MeleeMove:WaitForChild("MeleeMoveScript")
					local Handle
					local RightKickAnimationId = MorphCharacter:WaitForChild("RightKickAnimationId")
					local LeftKickAnimationId = MorphCharacter:WaitForChild("LeftKickAnimationId")
					local Transformation = CharacterPack:WaitForChild("Transformation"):Clone()
					local FlyScript = CharacterPack:WaitForChild("FlyScript"):Clone()
					local KiBeam
					if NAME == "Goku" or NAME == "Cell" or NAME == "Yamcha" then
						KiBeam = CharacterPack:WaitForChild("KiBeam"):Clone()
					elseif NAME == "Gohan" then
						KiBeam = CharacterPack:WaitForChild("Father-SonKamehameha"):Clone()
					elseif NAME == "Vegeta" then
						KiBeam = CharacterPack:WaitForChild("FinalFlash"):Clone()
					elseif NAME == "Piccolo" then
						KiBeam = CharacterPack:WaitForChild("SpecialBeamCannon"):Clone()
					elseif NAME == "Android16" then
						KiBeam = CharacterPack:WaitForChild("HellsFlash"):Clone()
					elseif NAME == "Krillin" then
						KiBeam = CharacterPack:WaitForChild("DestructoDisk"):Clone()
					else
						KiBeam = CharacterPack:WaitForChild("KiBall"):Clone()
					end
					local MeleeMoveName = MorphCharacter:WaitForChild("MeleeMoveName")
					local TransformationType = MorphCharacter:WaitForChild("TransformationType")
					local KiBlastName = MorphCharacter:WaitForChild("KiBlastName")
					local Animate = Character:WaitForChild("Animate")
					local Walk = Animate:WaitForChild("walk")
					local WalkAnim = Walk:WaitForChild("WalkAnim")
					local Jump = Animate:WaitForChild("jump")
					local JumpAnim = Jump:WaitForChild("JumpAnim")
					local Fall = Animate:WaitForChild("fall")
					local FallAnim = Fall:WaitForChild("FallAnim")
					local Head = Character:WaitForChild("Head")
					local Backpack = Player:WaitForChild("Backpack")
					local Soundtrack = PlayerGui:WaitForChild("Soundtrack")
					local Menu = ScreenGui:WaitForChild("Menu")
					local StoreButton = Menu:WaitForChild("StoreButton")
					local StoreMenu = Menu:WaitForChild("StoreMenu")
					
					Enabled = false
					Debounce = true
					
					------ Hide store graphic.
					StoreButton.Visible = false
					StoreMenu.Visible = false
					------ Change map information (text and music).
					CurrentMap.Text = "DRAGON BALL: CELL SAGA"
					Stats.Visible = false
					Soundtrack.SoundId = "rbxassetid://"..SOUNDTRACK_ID
					------ Remove current attire.
					for _, Item in pairs (Character:GetChildren()) do
						if (Item.Name or Item:GetPropertyChangedSignal("Name"):Wait()) == "Health" or Item:IsA("ForceField") or Item:IsA("BodyColors") or Item:IsA("Pants") or Item:IsA("Shirt") or Item:IsA("CharacterMesh") or Item:IsA("Accessory") or Item:IsA("ShirtGraphic") then
							Item:Destroy()
						elseif (Item.Name or Item:GetPropertyChangedSignal("Name"):Wait()) == "Head" then
							for _, Decal in pairs (Item:GetChildren()) do
								if Decal:IsA("Decal") or Decal:IsA("SpecialMesh") then
									Decal:Destroy()
								end
							end
						end
					end
					------ Give new attire with stats.
					for _, Item in pairs (MorphCharacter:GetChildren()) do					
						if Item:IsA("Color3Value") or Item:IsA("NumberValue") or Item:IsA("IntValue") or Item:IsA("StringValue") or Item:IsA("BodyColors") or Item:IsA("Pants") or Item:IsA("Shirt") or Item:IsA("CharacterMesh") or Item:IsA("Accessory") or Item:IsA("ShirtGraphic") then
							Item.Parent = Character
						elseif (Item.Name or Item:GetPropertyChangedSignal("Name"):Wait()) == "Head" then
							for _, Decal in pairs (Item:GetChildren()) do
								if Decal:IsA("Decal") then
									Decal.Parent = Head
								end
								Mesh:Clone().Parent = Head
							end
						elseif Item:IsA("Humanoid") then
							local MorphJumpPower = Item.JumpPower or Item:GetPropertyChangedSignal("JumpPower"):Wait()
							local MorphWalkSpeed = Item.WalkSpeed or Item:GetPropertyChangedSignal("WalkSpeed"):Wait()
							local MorphMaxHealth = Item.MaxHealth or Item:GetPropertyChangedSignal("MaxHealth"):Wait()
							local MorphHealth = Item.Health or Item:GetPropertyChangedSignal("Health"):Wait()
							-------- To avoid default animations, stop character for a short time.
							Humanoid.JumpPower = 0
							Humanoid.WalkSpeed = 0
							wait()
							Humanoid.JumpPower = MorphJumpPower
							Humanoid.WalkSpeed = MorphWalkSpeed
							Humanoid.MaxHealth = MorphMaxHealth
							Humanoid.Health = MorphHealth
						end
					end
					------ Animate character.
					WalkAnim.AnimationId = "rbxassetid://"..ANIME_RUN_ID
					JumpAnim.AnimationId = "rbxassetid://"..ANIME_RUN_ID
					FallAnim.AnimationId = "rbxassetid://"..ANIME_RUN_ID
					------ Give tools and scripts to make character fully function.
					if NAME == "FutureTrunks" then
						RightKickAnimationId:Destroy()
						LeftKickAnimationId:Destroy()
						MeleeMove:Destroy()
						MeleeMove = MorphCharacter:WaitForChild("Sword")
						Handle = MeleeMove:WaitForChild("Handle")
						Handle.Transparency = 0
						MeleeMoveScript = Handle:WaitForChild("SwordScript")
						MeleeMoveScript.Disabled = false
					end
					
					MeleeMove.Name = MeleeMoveName.Value or MeleeMoveName:GetPropertyChangedSignal("Value"):Wait()
					MeleeMove.Parent = Backpack
					
					Transformation.Name = TransformationType.Value or TransformationType:GetPropertyChangedSignal("Value"):Wait()
					Transformation.Parent = Backpack
					
					KiBeam.Name = KiBlastName.Value or KiBlastName:GetPropertyChangedSignal("Value"):Wait()
					KiBeam.Parent = Backpack
					
					FlyScript.Parent = Character
					
					Health.Parent = Character
					------ Teleport character.
					local Location = Vector3.new(math.random(461.978, 701.978), math.random(0, 2), math.random(-712.07, -472.07))
					Character:MoveTo(Location)
					------ Destroy remnants.
					MorphCharacter:Destroy()
					MorphCharacter = nil
					------ Increment uses.
					USES_CELL_SAGA[NAME] += 1
					local USES_CELL_SAGA_NEW_ENCODED = HttpService:JSONEncode(USES_CELL_SAGA)
					CellSagaPlayerUses.Value = USES_CELL_SAGA_NEW_ENCODED
					------
					wait(WAIT_TIME)
					------
					Enabled = true
					Debounce = false
				elseif (PLAYER_YEN >= YEN) and not OWNED_CELL_SAGA[NAME] then
					------
					Enabled = false
					Debounce = true
					------ Take the money away.
					Yen.Value -= YEN
					------ Give character to player.
					OWNED_CELL_SAGA[NAME] = true
					local OWNED_CELL_SAGA_NEW_ENCODED = HttpService:JSONEncode(OWNED_CELL_SAGA)
					OwnedCellSagaPlayers.Value = OWNED_CELL_SAGA_NEW_ENCODED
					------
					wait(WAIT_TIME)
					------
					Enabled = true
					Debounce = false
				end
				
			end
			
		end
		
	end)
	
end