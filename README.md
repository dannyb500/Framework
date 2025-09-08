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



# BUFFER

### EXAMPLE
```lua 
local BufferTest = self._index.Serialize.CFrame.serialize(CFrame.new(1,10,1))
print(BufferTest)
print(self._index.Serialize.CFrame.deserialize(BufferTest))
```

### CFRAME:
```lua
serialize: (CFrame) -> (buffer) -- saves Position and Orientation
deserialize: (buffer) -> (CFrame) -- ORIENTATION might have a slight amount of data loss
serializecf: (CFrame) -> (buffer) -- saves the whole cframe
deserializecf: (buffer) -> (CFrame) -- returns the whole cframe
```

### VEC3 | VEC2:
```lua
serialize: (Vector3 | Vector2) -> (buffer) 
deserialize: (buffer) -> (Vector3 | Vector2)  
```

### STR:
```lua
serialize: (String | Vector2) -> (buffer) 
deserialize: (buffer) -> (Vector3 | Vector2)  
```

