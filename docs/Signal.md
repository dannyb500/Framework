# SIGNALS

### EXAMPLE
```lua 
local Signal = self._index.Signal.new();

Signal:Connect(function(...: any)
    local Args = {...}
    print(Args)
end)

Signal:Fire("e")

Signal:Destroy();
```

# TYPES

```lua
new: () -> {
	new: (self: any) -> any,
	Connect: (self: any, Func: (...any) -> ()) -> RBXScriptConnection,
	Fire: (self: any, ...any) -> (),
	Destroy: (self: any) -> nil,
};

```
