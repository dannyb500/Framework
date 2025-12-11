local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Framework = require(ReplicatedStorage.Shared.Packets.Framework).new()
Framework:LoadModules({ReplicatedStorage.Modules})
Framework:Init()
Framework:Start()