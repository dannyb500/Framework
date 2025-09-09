local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packets.Signal)

local Server = {
	Test = "e";
	Test1 = Signal.new();
}

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

function Server:Init()
	print("Server Init")
	print(self)
end

function Server:Start()
	print("Server Start")
end

return Server
