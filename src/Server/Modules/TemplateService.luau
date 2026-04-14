local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packets.Signal)
local Types = require(ReplicatedStorage.Shared.Packets.Types);

local Server = {
	Test1 = Signal.new(false),
}
export type self = typeof(Server) & Types.FrameworkIndex;

-------------------------
-- SERVICES --¬
-------------------------

-------------------------
-- VARIABLES --
-------------------------

-------------------------¬
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
