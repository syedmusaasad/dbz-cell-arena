--[[ SCRIPT TOGGLES STORE ]]--

local Button = script.Parent
local Menu = Button.Parent
local Store = Menu:WaitForChild("StoreMenu")

--------------------------------------------------------------------------------

Button.Activated:Connect(function()
	local TEXT = Button.Text or Button:GetPropertyChangedSignal("Text"):Wait()
	
	if TEXT == "STORE" then
		Store.Visible = true;
		Button.Text = "CLOSE"
	else 
		Store.Visible = false;
		Button.Text = "STORE"
	end
end)