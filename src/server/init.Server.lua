local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Framework = require(ReplicatedStorage.Shared.Packets.Framework).new()
Framework:LoadModules({ServerScriptService.Server.Modules})
Framework:Init()
Framework:Start()