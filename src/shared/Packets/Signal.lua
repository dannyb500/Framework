
local Signal = {}
Signal.__index = Signal	

function Signal.new(is_unreliable: boolean)
	return {
		_SIGNAL = if is_unreliable then "UNRELIABLE" else "RELIABLE" 
	}
end 

return Signal