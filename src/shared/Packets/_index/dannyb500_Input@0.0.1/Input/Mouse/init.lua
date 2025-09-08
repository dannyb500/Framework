local UserInputService = game:GetService("UserInputService")

local Signal = require("../../dannyb500_Signal@0.0.1/Signal")

local Mouse = {}
Mouse.__index = Mouse

function Mouse.new()
	local self = setmetatable(Mouse,{})
	self.Mouse = game.Players.LocalPlayer:GetMouse()
	self.LeftDown = Signal.new()
	self.RightDown = Signal.new()
	self.LeftUp = Signal.new()
	self.RightUp = Signal.new()
	
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.LeftDown:Fire(true)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.RightDown:Fire(true)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.LeftUp:Fire(false)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.RightUp:Fire(false)
		end
	end)

	return self
end

function Mouse.IsLeftDown()
	return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

function Mouse.IsRightDown()
	return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end

return Mouse
