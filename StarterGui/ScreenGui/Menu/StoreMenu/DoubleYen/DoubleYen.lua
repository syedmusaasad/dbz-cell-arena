--[[ SCRIPT PROMPTS DOUBLE YEN PURCHASE ]]--

local ASSET_ID = 9906904
local TIME_PRESENT = 1

--------------------------------------------------------------------------------

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Multiplier = Player:WaitForChild("Multiplier")

--------------------------------------------------------------------------------

local Button = script.Parent

--------------------------------------------------------------------------------

local Enabled = true

--------------------------------------------------------------------------------

Button.Activated:Connect(function()
	local MULTIPLIER = Multiplier.Value or Multiplier:GetPropertyChangedSignal("Value"):Wait()
	local OWNS_ITEM
	
	local Success, Error = pcall(function()
		OWNS_ITEM = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, ASSET_ID)
	end)
	
	if Success then
		if not OWNS_ITEM and MULTIPLIER == 1 then
			MarketplaceService:PromptGamePassPurchase(Player, ASSET_ID)
		else
			if Enabled then
				Enabled = false
				
				Button.Text = "ALREADY OWNED"
				
				wait(TIME_PRESENT)
				
				Enabled = true
				
				Button.Text = "x2 YEN"
			end
		end
	else
		if Enabled then
			Enabled = false
			
			Button.Text = Error
			
			wait(TIME_PRESENT)
			
			Enabled = true
			
			Button.Text = "x2 YEN"
		end
	end
end)