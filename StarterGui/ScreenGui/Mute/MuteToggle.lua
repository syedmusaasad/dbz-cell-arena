--[[ SCRIPT TOGGLES MUTE ]]--

local Button = script.Parent
local ScreenGui = Button.Parent
local PlayerGui = ScreenGui.Parent
local Soundtrack = PlayerGui:WaitForChild("Soundtrack")

--------------------------------------------------------------------------------

Button.Activated:Connect(function()
	local TEXT = Button.Text or Button:GetPropertyChangedSignal("Text"):Wait()
	
	if TEXT == "🔊" then
		Soundtrack.Volume = 0
		Button.Text = "🔈"
	else
		Soundtrack.Volume = 0.5
		Button.Text = "🔊"
	end
end)

