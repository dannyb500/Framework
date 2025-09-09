# INPUT


### EXAMPLE 
# KEYBOARD:
```lua 
local Keyboard = self._index.Input.Keyboard.new()

Keyboard.KeyDown:Connect(function(Key: Enum.KeyCode)
	print("DOWN",Key)
end) 
Keyboard.KeyUp:Connect(function(Key: Enum.KeyCode)
	print("UP", Key)
end)
```
# GAMEPAD:
```lua 

local Gamepad = self._index.Input.Gamepad.new()
local isConnected = Gamepad.IsGamepadConnected()
print("ControllerIsConnected", isConnected)
Gamepad.ButtonDown:Connect(function(Key: Enum.KeyCode)
	print("DOWN",Key)
end) 
Gamepad.ButtonUp:Connect(function(Key: Enum.KeyCode)
	print("UP", Key)
end)

```
#
#### [Back](../README.md)