local UserInputService = game:GetService("UserInputService")
local HapticService = game:GetService("HapticService")

local Signal = require("../../dannyb500_Signal@0.0.1/Signal")
local Trove = require("../../../OpenSource/Trove")

local Gamepad = {}
Gamepad.__index = Gamepad

local GuiService = game:GetService("GuiService")

local function GetGamepad()
	for i,v in Enum.UserInputType:GetEnumItems() do
		if string.find(v.Name,"Gamepad") then
			return v
		end
	end
end

function Gamepad.new()
	local self = setmetatable({}, Gamepad)
	self.GAMEPAD = GetGamepad()
	self.ButtonUp = Signal.new()
	self.ButtonDown = Signal.new()
	self._trove = Trove.new()

	self._trove:Connect(UserInputService.GamepadConnected,function(_: Enum.UserInputType) 
		self.GAMEPAD = GetGamepad()
	end)

	
	self._trove:Connect(UserInputService.InputBegan,function(Input,Processed)
		if Processed then
			return
		end
		self.ButtonDown:Fire(Input.KeyCode)	
	end)

	self._trove:Connect(UserInputService.InputEnded,function(Input,Processed)
		if Processed then
			return
		end
		self.ButtonUp:Fire(Input.KeyCode)	
	end)
	
	return self
end

function Gamepad.IsButtonDown(Keycode:Enum.KeyCode, Gamepad)
	return UserInputService:IsGamepadButtonDown(Gamepad,Keycode)
end

function Gamepad:IsMotorSupported()
	return HapticService:IsMotorSupported(self.GAMEPAD,Enum.VibrationMotor.Small)
end

function Gamepad:PulseMotor(Motor: Enum.VibrationMotor,Time,Intensity: number)
	task.defer(function()
		if typeof(Motor) == "EnumItem" and Motor.EnumType == Enum.VibrationMotor then
			HapticService:SetMotor(self.GAMEPAD,Motor,Intensity)
			task.wait(Time)
			HapticService:SetMotor(self.GAMEPAD,Motor,0)
		end
	end)
end

function Gamepad:StopMotor(Motor: Enum.VibrationMotor)
	if Motor then
		self:PulseMotor(Motor,0,0)
	else
		for _,v in Enum.VibrationMotor:GetEnumItems() do
			self:PulseMotor(v,0,0)
		end
	end
end

function Gamepad.IsGamepadConnected()
	return UserInputService.GamepadEnabled
end

function Gamepad:IsConsole()
	return GuiService:IsTenFootInterface()
end

function Gamepad:GetUserInputType()
	return self.GAMEPAD
end

function Gamepad:Destroy()
	self._trove:Destroy()
end



return Gamepad
