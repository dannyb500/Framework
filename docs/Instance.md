# SIGNALS

### EXAMPLE
```lua 

local Player = game.Players.LocalPlayer
	local PlayerGui = Player:WaitForChild("PlayerGui")
	local Instance = self._index.Instance

	local function Text(Text: string)
		return Instance.new("TextLabel", {
			Size = UDim2.new(1, -20, 0, 50),
			Position = UDim2.new(0, 10, 0, 10),
			Text = Text or "",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSansBold,
			TextScaled = true,
		})
	end

	Instance.new("ScreenGui", {
		Parent = PlayerGui,
		["Children"] = {
			Instance.new("Frame", {
				Size = UDim2.new(0, 200, 0, 200),
				BackgroundColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.new(0.5, -100, 0.5, -100),
				AnchorPoint = Vector2.new(0.5, 0.5),
				["Children"] = {
					Text("Hello World!"),
					Instance.new("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
				},
			}),
			Instance.new("UIListLayout"),
		},
	})

```
#
#### [Back](../README.md)