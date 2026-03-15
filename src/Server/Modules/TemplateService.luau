local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packets.Signal)

local Server = {
	Test = "e",
	Test1 = Signal.new(false),
} :: Types.FrameworkPacket
export type self = typeof(Server) & Types.FrameworkIndex;

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

function Server.Init(self: self)
end

function Server.Start(self: self)
end

return Server
