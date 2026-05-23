local UserInputService = game:GetService("UserInputService")

local Signal = require("../../dannyb500_Signal/Signal")

local Mouse = {}
Mouse.__index = Mouse

function Mouse.new()
	local self = setmetatable({},Mouse)
	self.Mouse = game.Players.LocalPlayer:GetMouse()
	self.ButtonDown = Signal.new();
	self.RightDown = Signal.new();
	self.LeftDown = Signal.new();
	
	self.ButtonUp = Signal.new();
	self.RightUp = Signal.new();
	self.LeftUp = Signal.new();
	
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.LeftDown:Fire(true)
			self.ButtonDown:Fire(input.UserInputType)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.RightDown:Fire(true)
			self.ButtonDown:Fire(input.UserInputType)
		end
	end)

	UserInputService.InputEnded:Connect(function(input,processed)
		if processed then	
			return
		end
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.ButtonUp:Fire(input.UserInputType)
			self.LeftUp:Fire(false)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.ButtonUp:Fire(input.UserInputType)
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

function Mouse.IsButtonDown(Input)
	return UserInputService:IsMouseButtonPressed(Input)
end

return Mouse
