local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packets.Signal)

local Server = {
	Test = "e",
	Test1 = Signal.new(false),
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
end

function Server:Start()
end

return Server
