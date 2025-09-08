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
edit: (buffer,CFrame) -> (buffer)

serializecf: (CFrame) -> (buffer) -- saves the whole cframe
deserializecf: (buffer) -> (CFrame) -- returns the whole cframe
editcf: (buffer,CFrame) -> (buffer)

```

### VEC3 | VEC2:
```lua
serialize: (Vector3 | Vector2) -> (buffer) 
deserialize: (buffer) -> (Vector3 | Vector2)  
edit: (buffer,Vector3 | Vector2) -> (buffer)
```

### STR:
```lua
serialize: (string) -> (buffer) 
deserialize: (buffer,number) -> (string)  
edit: (buffer,string) -> (buffer)
```
