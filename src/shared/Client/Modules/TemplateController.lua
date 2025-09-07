local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client = {}

-------------------------
-- SERVICES --
-------------------------

-------------------------
-- VARIABLES --
-------------------------

-------------------------
-- PRIVATE FUNCTIONS --
-------------------------

local function Test()
    print("Test")
end

-------------------------
-- PUBLIC FUNCTIONS --
-------------------------

function Client:Test()
    Test()
end

-------------------------
-- FRAMEWORK INIT --
-------------------------

function Client:Init()
    print("Client Init")
	self:Test()
    print(self)
end

function Client:Start()
    print(self)
	print("Client Start")
end

return Client