local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Style = require(script.Parent.Conversion)
local Color = require(script.Parent.Color);

if game:GetService("RunService"):IsServer() then
	return {};
end

if not ReplicatedStorage:FindFirstChild("Design") then
	Instance.new("Folder",ReplicatedStorage).Name = "Design";
end

local coreSheet = Instance.new("StyleSheet",ReplicatedStorage.Design);
coreSheet.Name = "CoreSheet";

local CSS = {}

local Type = {
	COMMENT = "//";
	NEW_LINE = ";";
	COLON = ":";

	COLOR = "#";
	ELLIPSIS = ".";

	LEFT_BRACE = "{";
	RIGHT_BRACE = "}";

	PERCENT = "%%";
	PIXEL = "px";
}

local Syntax_ERR = {"="};

local ERR = {
	COLOR = "COMPILE_HEX_NULL";
	SYNTAX = "SYNTAX_ERR";
}

function CSS:Compile(Code: string)  
	local linesTable = string.split(Code, "\n")
	
	local RBX_VER = {};
	local POINTER = nil;
	local inBlock = false;
	
	for lineNumber, lineContent in ipairs(linesTable) do
		local line = string.gsub(lineContent," ","");
		
		for _,v in Syntax_ERR do
			if string.find(line,v) then return error(`ERR.SYNTAX_{v}`) end;
		end
		if string.find(line,Type.COMMENT) then
			continue;
		end
		
		if string.find(line,Type.ELLIPSIS) then
			local selectorName = string.match(line, "%" .. Type.ELLIPSIS .. "([%w_]+)");
			if selectorName then
				RBX_VER[selectorName] = {};
				POINTER = RBX_VER[selectorName]
				inBlock = string.find(line, Type.LEFT_BRACE, 1, true) ~= nil
			end
		end

		if string.find(line,Type.LEFT_BRACE) then --// Start of code block;
			inBlock = true;
		elseif string.find(line,Type.RIGHT_BRACE) then --// End of code block;
			inBlock = false;
			POINTER = RBX_VER
		end

		if not inBlock and not POINTER then
			continue
		end

		local declaration = string.gsub(line, Type.NEW_LINE .. "$", "");

		local property, value = string.match(declaration, "([^" .. Type.COLON .. "]+)" .. Type.COLON .. "(.*)");
		if property and value then
			property = string.match(property, "^%s*(.-)%s*$");
			value = string.match(value, "^%s*(.-)%s*$");


			--// Values
			if string.find(value,Type.COLOR) then
				value = Color3.fromHex(value)
			elseif property == "color" or string.find(property,"color") then
				if not Color[value] then
					error(ERR.COLOR,4)
				end
				value = Color3.fromHex(Color[value])
			elseif string.find(value,Type.PIXEL) then
				value = tonumber(string.sub(value,0,string.len(value) - 2))
			elseif string.find(value,Type.PERCENT) then
				value = tonumber(string.sub(value,0,string.len(value) - 2)) / 10;
			end

			warn(property, " | ",value)

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

				--// if value is below 1 it sets to scale value else its offset value
				style:SetProperties({CornerRadius = UDim.new(if value <= 1 then value else 0, if value > 1 then value else 0)})
				value = style
			end

			POINTER[property] = value
		end
	end

	return RBX_VER
end

function CSS:ApplyStyle(Tbl: {})
	for i, v in Tbl do
		local rule = Instance.new("StyleRule")
		rule.Name = i;
		rule.Selector = `.{i}`;
			
		local Apply = {}
		for j,k in v do
			if typeof(k) ~= "Instance" then
				Apply[j] = k;
				continue
			end
			k.Parent = rule;
		end
		rule:SetProperties(Apply)
	end
end

return CSS