# SIGNALS

### EXAMPLE
```lua 

--------------------------
--// CONNECTION SIGNALS
--------------------------

local Signal = self._index.Signal.new();

Signal:Connect(function(...: any)
    local Args = {...}
    print(Args)
end)

Signal:Fire("e")

Signal:Destroy();


--------------------------
--// SERVICE SIGNALS
--// For creating Remote
--// events on the server
--------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packets.Signal)

local Unreliable = true

local Server = {
	EventName = Signal.new(Unreliable)
} -- Service Module

```



# TYPES

```lua
--/ScriptConnection
new: () -> {
	new: (self: any) -> any,
	Connect: (self: any, Func: (...any) -> ()) -> RBXScriptConnection,
	Fire: (self: any, ...any) -> (),
	Destroy: (self: any) -> nil,
};

--/Service
new: (Unreliable: boolean) -> (string) -- Converts to a table on framework init 

```
#
#### [Back](../README.md)