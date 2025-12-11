local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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

	local Compiler = self._index.CSS
	local css_input = [[
        .container {
            background-color: white;
            border-radius: 10%;
            opacity: 60%;
        }
        .header {
            background-color: white;
            border-radius: 100%;
            opacity: 60%;

           //padding: 100%;
        }◙
    ]]


	local compiled = Compiler:Compile(css_input);
	Compiler:ApplyStyle(compiled)
	print(compiled)
	local UI = self._index.UI.new();
	UI:LoadStyleSheet("CoreSheet")
	UI:CreateElement("Frame", {
		Size = UDim2.new(0.2,0,0.2,0);
		Tag = "container";
	}, 
	{
		UI:CreateElement("ImageLabel",{},{});

		UI:CreateElement("Frame", {
			Size = UDim2.new(0.7,0,0.7,0);
			Position = UDim2.new(.5,0,.5,0);
			AnchorPoint = Vector2.new(.5,.5);
			Tag = "header";
			[UI.Enum.Enter] = function()
				print("hover")
			end;
		},{
			UI:CreateElement("TextButton",{
                AnchorPoint = Vector2.new(.5,.5);
				Position = UDim2.new(.5,0,.5,0);
                Size = UDim2.new(1,0,1,0);
                BackgroundTransparency = 1;

				[UI.Enum.Activated] = function()
					print("clicked")
				end;},{}
			);
		})
	})

end

function Client:Start()

end

return Client
