local UserInputService = game:GetService("UserInputService")
local Signal = require("../../dannyb500_Signal@0.0.1/Signal")

local Mobile = {}
Mobile.__index = Mobile

function Mobile.new()
	local self = setmetatable({}, Mobile)

	self.FingerDown = Signal.new()
	self.FingerUp = Signal.new()
	self.TouchMoved = Signal.new()
	self.LastPosition = Vector2.new()
	self.ActiveTouches = {} 

	UserInputService.TouchStarted:Connect(function(input, gameProcessed)
		local position = Vector2.new(input.Position.X, input.Position.Y)
		self.LastPosition = position
		self.ActiveTouches[input] = position
		self.FingerDown:Fire(input)
	end)

	UserInputService.TouchMoved:Connect(function(input, gameProcessed)
		local position = Vector2.new(input.Position.X, input.Position.Y)
		self.LastPosition = position
		self.ActiveTouches[input] = position
		self.TouchMoved:Fire(input)
	end)

	UserInputService.TouchEnded:Connect(function(input, gameProcessed)
		self.ActiveTouches[input] = nil
		self.FingerUp:Fire(input)
	end)

	return self
end

function Mobile:GetFingerPosition(input)
	return self.ActiveTouches[input] or Vector2.new()
end

function Mobile:GetClosestFinger(position)
	local closestInput = nil
	local closestDistance = math.huge

	for input, touchPosition in pairs(self.ActiveTouches) do
		local distance = (touchPosition - position).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			closestInput = input
		end
	end

	return closestInput
end


function Mobile.IsMobileDevice()
	return UserInputService.TouchEnabled
end

function Mobile:GetActiveFingers()
	return self.ActiveTouches
end

function Mobile:IsTouchDown()
	return next(self.ActiveTouches) ~= nil
end

return Mobile