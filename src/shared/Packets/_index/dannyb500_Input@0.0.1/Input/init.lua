local Input = {}

Input.Keyboard = require(script:WaitForChild("Keyboard"))
Input.Gamepad = require(script:WaitForChild("Gamepad"))
Input.Mobile = require(script:WaitForChild("Mobile"))
Input.Mouse = require(script:WaitForChild("Mouse"))

return Input
