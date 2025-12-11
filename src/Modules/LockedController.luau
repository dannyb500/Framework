local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Packets:WaitForChild("Types"))

local Client = {
	_READONLY = true;
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

end

function Client:Start()
	-- self.thing = "e" -- will prevent due to read-only
end

return Client
