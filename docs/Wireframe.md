# WIREFRAME (WireframeHandleAdornment)

### EXAMPLE
```lua 

local Wires = self._index.Wire;
--Color PATH: ReplicatedStorage.Shared.Packets._index.dannyb500_Str@0.0.1.Colors

RunService:BindToRenderStep("DoorWires",1,function()
	Wires:SetColor(255,0,0) -- you can also use strings from the texteditor color module
	Wires:DrawLine(DoorPos,CharPos)
	Wires:DrawText(DoorPos,"[E] TO OPEN DOOR")
end)

```



# TYPES

```lua

DrawLine: (from: Vector3, to: Vector3) -> nil;
DrawText: (position: Vector3,any: string) -> nil;

SetColor: (Color3: Color3 | string) -> nil;

```
#
#### [Back](../README.md)