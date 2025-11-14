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
   local UI = self._index.UI.new();
   UI:LoadStyleSheet("TEST")

   UI:CreateElement("Frame", {
        Size = UDim2.new(.5,0,.5,0);
    }, 
    {
        UI:CreateElement("TextButton",{},{});
        UI:CreateElement("ImageLabel",{},{
            UI:CreateElement("Frame")
        })
    })
    
end

function Client:Start()

end

return Client
