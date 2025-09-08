# Packets;
Framework

```lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = PATH_TO_MODULES

local Framework = require(ReplicatedStorage.Shared.Packets.Framework).new()
Framework:LoadModues(Modules);
Framework:Init();
Framework:Start();

```
# Classes: _index
[Buffers](docs/Buffer.md)


