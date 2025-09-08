local Trove = require("../../../OpenSource/Trove")
local Signal = require("../../dannyb500_Signal@0.0.1/Signal")

local Keyboard = {}
Keyboard.__Index = Keyboard

local UIS = game:GetService("UserInputService")
function Keyboard.new()
	local self = setmetatable({}, Keyboard)
	
	self._trove = Trove.new()
	
	self.KeyDown = Signal.new()
	self.KeyUp = Signal.new()
	
	self._trove:Connect(UIS.InputBegan, function(Input, Processed)
		if Processed then
			return
		end
		
		self.KeyDown:Fire(Input.KeyCode)
	end)
	
	self._trove:Connect(UIS.InputEnded, function(Input, Processed)
		if Processed then
			return
		end
		
		self.KeyUp:Fire(Input.KeyCode)
	end)
	
	return self
end

function Keyboard.IsKeyDown(Keycode:Enum.KeyCode)
	return UIS:IsKeyDown(Keycode)
end

function Keyboard:Destroy()
	self._trove:Clean()
end

return Keyboard