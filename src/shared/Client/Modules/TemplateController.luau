local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Packets:WaitForChild("Types"))

local Client = {
	Test = "e",
} :: Types.FrameworkPacket

-------------------------
-- SERVICES --
-------------------------

-------------------------
-- VARIABLES --
-------------------------

-------------------------
-- PRIVATE FUNCTIONS --
-------------------------

-------------------------
-- PUBLIC FUNCTIONS --
-------------------------

-------------------------
-- FRAMEWORK INIT --
-------------------------

function Client:Init()
	print("Client Init")
	-- local Keyboard = self._index.Input.Keyboard.new()
	-- Keyboard.KeyDown:Connect(function(Key: Enum.KeyCode)
	-- 	print("DOWN",Key)
	-- end) 
	-- Keyboard.KeyUp:Connect(function(Key: Enum.KeyCode)
	-- 	print("UP", Key)
	-- end)

	-- local Gamepad = self._index.Input.Gamepad.new()
	-- local isConnected = Gamepad.IsGamepadConnected()
	-- print("ControllerIsConnected", isConnected)
	-- Gamepad.ButtonDown:Connect(function(Key: Enum.KeyCode)
	-- 	print("DOWN",Key)
	-- end) 
	-- Gamepad.ButtonUp:Connect(function(Key: Enum.KeyCode)
	-- 	print("UP", Key)
	-- end)

	local SignalTest = self._events.TemplateService.Test1
	SignalTest:Connect(function(Msg: string)
		print("Signal Fired", Msg)
		SignalTest:Fire("info for the server")
	end)
end

function Client:Start()
	print("Client Start")
end

return Client
