--[[ SCRIPT SETS UP SERVER ]]--

local TIME_PRESENT = 1
local CLOSE_TIME = 2
local LEADERBOARD_REFRESH = 60
local DAMAGE_DIVIDER = 500
local DAY = 86400
local DAILY_REWARD = 5
local DOUBLE_YEN_ID = 9906904
local HUNDRED_YEN_ID = 1075269921
local DEFAULT_OWNED_CELL_SAGA = {
	CellJr = false,
	Yamcha = false,
	Krillin = false,
	Tien = false,
	Piccolo = false,
	FutureTrunks = false,
	Vegeta = false,
	Goku = false,
	Android17 = false,
	Android18 = false,
	Android16 = false,
	Cell = false,
	Gohan = false
}
local DEFAULT_OWNED_CELL_SAGA_ENCODED
local DEFAULT_USES_CELL_SAGA = {
	CellJr = 0,
	Yamcha = 0,
	Krillin = 0,
	Tien = 0,
	Piccolo = 0,
	FutureTrunks = 0,
	Vegeta = 0,
	Goku = 0,
	Android17 = 0,
	Android18 = 0,
	Android16 = 0,
	Cell = 0,
	Gohan = 0
}
local DEFAULT_USES_CELL_SAGA_ENCODED

--------------------------------------------------------------------------------

local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local YenStore = DataStoreService:GetDataStore("PlayerYen", "0")
local KillsStore = DataStoreService:GetOrderedDataStore("KillsStore", "0")
local DamageStore = DataStoreService:GetOrderedDataStore("DamageStore", "0")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DailyRewardRemoteEvent = ReplicatedStorage:WaitForChild("DailyRewardRemoteEvent")
local SaveRemoteEvent = ReplicatedStorage:WaitForChild("SaveRemoteEvent")
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")
local Content = ServerStorage:WaitForChild("Content")

--------------------------------------------------------------------------------

-- Initalize values.

DEFAULT_OWNED_CELL_SAGA_ENCODED = HttpService:JSONEncode(DEFAULT_OWNED_CELL_SAGA)
DEFAULT_USES_CELL_SAGA_ENCODED = HttpService:JSONEncode(DEFAULT_USES_CELL_SAGA)

--------------------------------------------------------------------------------

local function Save(Player)
	local Leaderstats = Player:WaitForChild("leaderstats")
	local Yen = Leaderstats:WaitForChild("Yen")
	local Kills = Leaderstats:WaitForChild("Kills")
	local Damage = Leaderstats:WaitForChild("Damage")
	local UserTime = Player:WaitForChild("UserTime")
	local CellSagaPlayerUses = Player:WaitForChild("CellSagaPlayerUses")
	local OwnedCellSagaPlayers = Player:WaitForChild("OwnedCellSagaPlayers")
	
	local YEN = Yen.Value or Yen:GetPropertyChangedSignal("Value"):Wait()
	local KILLS = Kills.Value or Kills:GetPropertyChangedSignal("Value"):Wait()
	local DAMAGE = Damage.Value or Damage:GetPropertyChangedSignal("Value"):Wait()
	local USER_TIME = UserTime.Value or UserTime:GetPropertyChangedSignal("Value"):Wait()
	local USES_CELL_SAGA = CellSagaPlayerUses.Value or CellSagaPlayerUses:GetPropertyChangedSignal("Value"):Wait()
	local OWNED_CELL_SAGA = OwnedCellSagaPlayers.Value or OwnedCellSagaPlayers:GetPropertyChangedSignal("Value"):Wait()
	
	-- Save values.
		
	local Saves = {
		YEN,
		KILLS,
		DAMAGE,
		USER_TIME,
		OWNED_CELL_SAGA,
		USES_CELL_SAGA
	}
	
	YenStore:SetAsync(Player.UserId, Saves)
end

--------------------------------------------------------------------------------

local function DestroyFrame(Contents)
	for _, Frame in pairs (Contents:GetChildren()) do
		if Frame:IsA("Frame") then
			Frame:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

local function UpdateLeaderboard(Page, Contents)
	
	local Broken = 0
	
	-- Add players, their stats, and update with new frame.
	
	for RANK, CurrentData in ipairs (Page) do
		local KEY = CurrentData.key
		local USER_NAME
		
		local Success, Error = pcall(function()
			USER_NAME = Players:GetNameFromUserIdAsync(KEY)
		end)
		
		if Success then
			local CONTENT = CurrentData.value
			local OnLeaderboard = false
			
			for _, CurrentContent in pairs (Contents:GetChildren()) do
				if CurrentContent:IsA("Frame") then
					local Player = CurrentContent:WaitForChild("Player")
					local TEXT = Player.Text or Player:GetPropertyChangedSignal("Text"):Wait()
					
					if TEXT == USER_NAME then
						OnLeaderboard = true
						break
					end
				end
			end
			
			if CONTENT and not OnLeaderboard then
				local LeaderboardFrame = Content:Clone()
				local Player = LeaderboardFrame:WaitForChild("Player")
				local Content = LeaderboardFrame:WaitForChild("Content")
				local Rank = LeaderboardFrame:WaitForChild("Rank")
				Player.Text = USER_NAME
				Content.Text = CONTENT
				Rank.Text = "#"..(RANK - Broken)
				LeaderboardFrame.Parent = Contents
			end
		else
			Broken += 1 -- Count how many times broke.
			
			continue -- Go to next one.
		end
	end
end

--------------------------------------------------------------------------------

spawn(function()
	local AMOUNT_PER_PAGE = 10
	
	local Lobby = workspace:WaitForChild("Lobby")
	local Leaderboards = Lobby:WaitForChild("Leaderboards")
	local HighestKills = Leaderboards:WaitForChild("HighestKills")
	local HighestKillsSurfaceGui = HighestKills:WaitForChild("SurfaceGui")
	local HighestKillsContents = HighestKillsSurfaceGui:WaitForChild("Contents")
	local KillsInformation = HighestKillsSurfaceGui:WaitForChild("Information")
	local HighestDamage = Leaderboards:WaitForChild("HighestDamage")
	local HighestDamageSurfaceGui = HighestDamage:WaitForChild("SurfaceGui")
	local HighestDamageContents = HighestDamageSurfaceGui:WaitForChild("Contents")
	local DamageInformation = HighestDamageSurfaceGui:WaitForChild("Information")
	
	repeat
		local KillsData
		local DamageData
		
		local Success, Error = pcall(function()
			KillsData = KillsStore:GetSortedAsync(false, AMOUNT_PER_PAGE)
			DamageData = DamageStore:GetSortedAsync(false, AMOUNT_PER_PAGE)
		end)
		
		if Success then
			local KillsPage = KillsData:GetCurrentPage()
			local DamagePage = DamageData:GetCurrentPage()
			
			-- Search through each player and save their data to ordered data stores.
			
			for _, Player in pairs (Players:GetPlayers()) do
				local Leaderstats = Player:WaitForChild("leaderstats")
				local Kills = Leaderstats:WaitForChild("Kills")
				local Damage = Leaderstats:WaitForChild("Damage")
				
				
				local KILLS = Kills.Value or Kills:GetPropertyChangedSignal("Value"):Wait()
				local DAMAGE = Damage.Value or Damage:GetPropertyChangedSignal("Value"):Wait()
				
				local PlayerSuccess, PlayerError = pcall(function()
					Players:GetNameFromUserIdAsync(Player.UserId)
				end)
				
				if PlayerError then
					continue
				end
				
				KillsStore:SetAsync(Player.UserId, KILLS)
				DamageStore:SetAsync(Player.UserId, DAMAGE)
			end
			
			-- 
			
			DestroyFrame(HighestKillsContents)
			DestroyFrame(HighestDamageContents)
			
			UpdateLeaderboard(KillsPage, HighestKillsContents)
			UpdateLeaderboard(DamagePage, HighestDamageContents)
		else
			
			-- Replace text with error message.
			
			KillsInformation.Text = Error
			DamageInformation.Text = Error
		end
	until not wait(LEADERBOARD_REFRESH)
end)

--------------------------------------------------------------------------------

Players.PlayerAdded:Connect(function(Player)	
	
	-- Get previous save file.
	
	local Saves
	
	local Success, Error = pcall(function()
		Saves = YenStore:GetAsync(Player.UserId)
	end)
	
	-- If previous save file exists, set the values accordingly.
	
	if Success then
		---- Create leaderboard.
		local Leaderstats = Instance.new("Folder", Player)
		Leaderstats.Name = "leaderstats"
		
		---- Set the yen.
		local Yen = Instance.new("IntValue", Leaderstats)
		Yen.Name = "Yen"
		if Saves then
			Yen.Value = Saves[1] or 45
		else
			Yen.Value = 45
		end
		
		---- Set the kills.
		local Kills = Instance.new("IntValue", Leaderstats)
		Kills.Name = "Kills"
		if Saves then
			Kills.Value = Saves[2] or 0
		else
			Kills.Value = 0
		end
		
		---- Create local kills.
		local LocalKills = Instance.new("IntValue", Player)
		LocalKills.Name = "LocalKills"
		LocalKills.Value = 0
		
		---- Set the damage.
		local Damage = Instance.new("IntValue", Leaderstats)
		Damage.Name = "Damage"
		if Saves then
			Damage.Value = Saves[3] or 0
		else
			Damage.Value = 0
		end
		
		---- Create local damage.
		local LocalDamage = Instance.new("IntValue", Player)
		LocalDamage.Name = "LocalDamage"
		LocalDamage.Value = 0
		
		---- Set the multiplier.
		local Multiplier = Instance.new("IntValue", Player)
		Multiplier.Name = "Multiplier"
		
		local OWNS_ITEM
	
		local PassSuccess, PassError = pcall(function()
			OWNS_ITEM = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, DOUBLE_YEN_ID)
		end)
		
		if PassSuccess then
			if OWNS_ITEM then
				Multiplier.Value = 2 -- Give double yen.
			else
				Multiplier.Value = 1 -- Give single yen.
			end
		else
			Player:Kick(PassError)
		end
		
		---- Set the user time.
		local UserTime = Instance.new("IntValue", Player)
		UserTime.Name = "UserTime"
		if Saves then
			UserTime.Value = Saves[4] or 0
		else
			UserTime.Value = 0
		end
		
		---- Set the owned players for Dragon Ball: Cell Saga.
		local OwnedCellSagaPlayers = Instance.new("StringValue", Player)
		OwnedCellSagaPlayers.Name = "OwnedCellSagaPlayers"
		if Saves then
			OwnedCellSagaPlayers.Value = Saves[5] or DEFAULT_OWNED_CELL_SAGA_ENCODED
		else
			OwnedCellSagaPlayers.Value = DEFAULT_OWNED_CELL_SAGA_ENCODED
		end
		
		---- Set the uses for Dragon Ball: Cell Saga players.
		local CellSagaPlayerUses = Instance.new("StringValue", Player)
		CellSagaPlayerUses.Name = "CellSagaPlayerUses"
		if Saves then
			CellSagaPlayerUses.Value = Saves[6] or DEFAULT_USES_CELL_SAGA_ENCODED
		else
			CellSagaPlayerUses.Value = DEFAULT_USES_CELL_SAGA_ENCODED
		end
		
		-- If it's been 24 hours, give player daily reward.
		
		local USER_TIME = UserTime.Value or UserTime:GetPropertyChangedSignal("Value"):Wait()
		local TIME_PASSED = os.time() - USER_TIME
		local MULTIPLIER = Multiplier.Value or Multiplier:GetPropertyChangedSignal("Value"):Wait()
		
		if TIME_PASSED >= DAY then
			UserTime.Value = os.time() -- Reset timer.
			Yen.Value += DAILY_REWARD * MULTIPLIER -- Give reward.
			DailyRewardRemoteEvent:FireClient(Player) -- Pop up message.
		end
	else
		Player:Kick(Error)
	end
end)

--------------------------------------------------------------------------------

game:BindToClose(function()
	wait(CLOSE_TIME)
end)

--------------------------------------------------------------------------------

Players.PlayerRemoving:Connect(function(Player)
	local Leaderstats = Player:FindFirstChild("leaderstats")
	if Leaderstats then
		local Yen = Leaderstats:WaitForChild("Yen")
		local LocalKills = Player:WaitForChild("LocalKills")
		local LocalDamage = Player:WaitForChild("LocalDamage")
		local Multiplier = Player:WaitForChild("Multiplier")
		
		local MULTIPLIER = Multiplier.Value or Multiplier:GetPropertyChangedSignal("Value"):Wait()
		local LOCAL_KILLS = LocalKills.Value or LocalKills:GetPropertyChangedSignal("Value"):Wait()
		local LOCAL_DAMAGE = LocalDamage.Value or LocalDamage:GetPropertyChangedSignal("Value"):Wait()
		local LOCAL_YEN = math.floor((LOCAL_KILLS + (LOCAL_DAMAGE / DAMAGE_DIVIDER)) * MULTIPLIER)
		
		-- Assign and reset local values.
		
		Yen.Value += LOCAL_YEN
		LocalKills.Value = 0
		LocalDamage.Value = 0
		
		Save(Player)
	end
end)

--------------------------------------------------------------------------------

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(Player, ASSET_ID, WasPurchased)
	local Leaderstats = Player:WaitForChild("leaderstats")
	local Multiplier = Player:WaitForChild("Multiplier")
	
	if WasPurchased and ASSET_ID == DOUBLE_YEN_ID then
		Multiplier.Value = 2 -- Give double yen for this ID.
	end
end)

--------------------------------------------------------------------------------

MarketplaceService.ProcessReceipt = function(ReceiptInfo)
	local Player
	
	local Success, Error = pcall(function()
		Player = Players:GetPlayerByUserId(ReceiptInfo.PlayerId)
	end)
	
	local Leaderstats = Player:WaitForChild("leaderstats")
	local Yen = Leaderstats:WaitForChild("Yen")
	
	if not Success or not Player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	if ReceiptInfo.ProductId == HUNDRED_YEN_ID then
		Yen.Value += 100 -- Give 100 yen for this ID.
	end
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

--------------------------------------------------------------------------------

SaveRemoteEvent.OnServerEvent:Connect(Save)