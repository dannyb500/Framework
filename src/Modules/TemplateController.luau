local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Packets:WaitForChild("Types"))

local Client = {} :: Types.FrameworkIndex
export type self = typeof(Client) & Types.FrameworkIndex;

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

function Client.Init(self: self)
end

function Client.Start(self: self)
end

return Client
