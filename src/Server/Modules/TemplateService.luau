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
	print("Server Init")
	print(self)
	self.Test1:Connect(function(Player: Player, Msg: string)
		print(`{Player.Name} | Signal: {Msg}`)
	end)
	while true do
		task.wait(1)
		self.Test1:Fire("info for client")
	end
end

function Server:Start()
	print("Server Start", self)
end

return Server
