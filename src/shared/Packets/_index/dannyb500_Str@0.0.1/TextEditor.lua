
local ColorList = require("./Colors") -- colorname~ : r~ hi~
local TextEditor = {}

TextEditor.suffixes = {
	"", "K", "M", "B", "T", "qd", "qt", "sx", "sp", "oc", "n", "Dc", "UD", "Dd",
	"Td", "Qtd", "QN", "SD", "sd", "od", "nd", "DD", "TD",
}

function TextEditor:Format(str)
	local newstr = string.gsub(str, "(%a+)~(.-)~", function(color, message)
		local colorValue = ColorList[color]
		if colorValue then
			local hex = "#" .. colorValue:ToHex()
			return '<font color="' .. hex .. '">' .. message .. '</font>'
		else
			return message
		end
	end)
	return newstr
end

-- Format number with commas
function TextEditor:GetNumber(value)
	local formatted = tostring(value):reverse():gsub("(%d%d%d)", "%1,")
	formatted = formatted:reverse():gsub("^,", "")
	return formatted
end


return TextEditor