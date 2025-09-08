local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
	print("--- Framework Client ---")
	print(self)

	local BufferTest = self._index.Serialize.CFrame.serialize(CFrame.new(1,10,1))
	print(BufferTest)
	print(self._index.Serialize.CFrame.deserialize(BufferTest))
	print("------------------------")
end

function Client:Start()
	print("Client Start")
end

return Client
