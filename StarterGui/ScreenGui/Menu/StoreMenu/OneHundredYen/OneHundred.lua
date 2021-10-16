--[[ SCRIPT PROMPTS ONE HUNDREN YEN PURCHASE ]]--

local ASSET_ID = 1075269921

--------------------------------------------------------------------------------

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

--------------------------------------------------------------------------------

local Button = script.Parent

--------------------------------------------------------------------------------

Button.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(Player, ASSET_ID)
end)