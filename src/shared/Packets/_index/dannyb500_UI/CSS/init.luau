local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Style = require(`./CSS/Conversion`)
local Color = require(`./CSS/Color`)

if game:GetService("RunService"):IsServer() then
	return {}
end

if not ReplicatedStorage:FindFirstChild("Design") then
	Instance.new("Folder", ReplicatedStorage).Name = "Design"
end

local coreSheet = Instance.new("StyleSheet", ReplicatedStorage.Design)
coreSheet.Name = "CoreSheet"

local CSS = {}
CSS.__index = CSS;

local Type = {
	COMMENT = "//",
	NEW_LINE = ";",
	COLON = ":",

	COLOR = "#",
	ELLIPSIS = ".",

	LEFT_BRACE = "{",
	RIGHT_BRACE = "}",

	PERCENT = "%%",
	PIXEL = "px",
}

local Syntax_ERR = { "=" }

local ERR = {
	COLOR = "COMPILE_HEX_NULL",
	SYNTAX = "SYNTAX_ERR",
}

function CSS.new(Name: string)
	local self = setmetatable({},  CSS)
	self.StyleSheet = Instance.new("StyleSheet", ReplicatedStorage.Design)
	self.StyleSheet.Name = Name or "UnnamedSheet"
	self.Compiled = {}
	return self
end

function CSS:Compile(Code: string)
	local linesTable = string.split(Code, "\n")

	local RBX_VER = {}
	local POINTER = nil
	local inBlock = false

	for lineNumber, lineContent in ipairs(linesTable) do
		local line = string.gsub(lineContent, " ", "")

		for _, v in Syntax_ERR do
			if string.find(line, v) then
				return error(`ERR.SYNTAX_{v}`)
			end
		end
		if string.find(line, Type.COMMENT) then
			continue
		end

		if string.find(line, Type.ELLIPSIS) then
			local selectorName = string.match(line, "%" .. Type.ELLIPSIS .. "([%w_]+)")
			if selectorName then
				if not RBX_VER[selectorName] then
					RBX_VER[selectorName] = {}
				end

				POINTER = RBX_VER[selectorName]
				inBlock = string.find(line, Type.LEFT_BRACE, 1, true) ~= nil
				
				--// Pseudo-classes
				if string.find(line, Type.COLON) then
					local event = string.match(line, "%" .. Type.COLON .. "([%w_]+)")
					local fullKey = `{selectorName}:{event}`

					if not RBX_VER[fullKey] then
						RBX_VER[fullKey] = {}
					end
					POINTER = RBX_VER[fullKey]
				end
			end
		end

		if string.find(line, Type.LEFT_BRACE) then --// Start of code block;
			inBlock = true
		elseif string.find(line, Type.RIGHT_BRACE) then --// End of code block;
			inBlock = false
			POINTER = RBX_VER
		end

		if not inBlock and not POINTER then
			continue
		end

		local declaration = string.gsub(line, Type.NEW_LINE .. "$", "")
		local property, value = string.match(declaration, "([^" .. Type.COLON .. "]+)" .. Type.COLON .. "(.*)")
		
		if property and value then
			if string.find(value, Type.LEFT_BRACE) then
				continue
			end
			property = string.match(property, "^%s*(.-)%s*$")
			value = string.match(value, "^%s*(.-)%s*$")
			
			--// Values
			if string.find(value, Type.COLOR) then
				value = Color3.fromHex(value)
			elseif property == "color" or string.find(property, "color") then
				if not Color[value] then
					error(ERR.COLOR, 4)
				end
				value = Color3.fromHex(Color[value])
			elseif string.find(value, Type.PIXEL) then
				value = tonumber(string.sub(value, 0, string.len(value) - 2))
			elseif string.find(value, Type.PERCENT) then
				value = tonumber(string.sub(value, 0, string.len(value) - 1)) / 100
			end
			
			
			if tonumber(value) then
				value = tonumber(value)
			end

			--// Properties
			if Style[property] then
				if typeof(Style[property]) == "function" then
					property = Style[property](value)
				else
					property = Style[property]
				end
			end
			
			if property == "UICorner" then
				local style = Instance.new("StyleRule")
				style.Name = "::UICorner"
				style.Selector = "::UICorner"

				style:SetProperties({
					CornerRadius = UDim.new(if value <= 1 then value else 0, if value > 1 then value else 0),
				})
				value = style
			elseif property == "UIPadding" then
				local style = Instance.new("StyleRule")
				style.Name = "::UIPadding"
				style.Selector = "::UIPadding"
				
				local Scale = if value <= 1 then value else 0
				local Offset = if value > 1 then value else 0
				
				style:SetProperties({
					PaddingBottom = UDim.new(Scale, Offset);
					PaddingLeft   = UDim.new(Scale, Offset);
					PaddingRight  = UDim.new(Scale, Offset);
					PaddingTop    = UDim.new(Scale, Offset);
				})
				value = style
			elseif property == "UIListLayout" then
				local style = Instance.new("StyleRule")
				style.Name = "::UIListLayout"
				style.Selector = "::UIListLayout"
				
				local Scale = if value <= 1 then value else 0
				local Offset = if value > 1 then value else 0
				
				style:SetProperties({
					Padding = UDim.new(Scale, Offset);
				})
				
				value = style
			end
			POINTER[property] = value
		end
	end
	self.Compiled = RBX_VER
	print(self.Compiled)
	return
end

function CSS:ApplyStyle()
	for i, v in self.Compiled do
		local rule = Instance.new("StyleRule")
		rule.Name = i
		rule.Selector = `.{i}`
		rule.Parent = self.StyleSheet;

		local Apply = {}
		
		task.spawn(function()
			--// Event
			if string.find(i, Type.COLON) then
				local split = string.split(i, Type.COLON)
				local event = string.gsub(split[2], " ", "")

				rule.Selector = `:{event}`
				rule.Name = `:{event}`
				rule.Parent = self.StyleSheet:WaitForChild(split[1])
			end
			
			--// Applies Properties
			for j, k in v do
				if typeof(k) ~= "Instance" then
					Apply[j] = k
					continue
				end
				k.Parent = rule
			end
			rule:SetProperties(Apply)
		end)
	end
end

return CSS
