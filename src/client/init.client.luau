local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Framework = require(ReplicatedStorage.Shared.Packets.Framework).new()
Framework:LoadModules({ReplicatedStorage.Shared.Client.Modules})
Framework:Init()
Framework:Start()