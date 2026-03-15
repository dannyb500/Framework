return function (condition, message)
	if not condition then
		if not message then
			return true
		end
		error(message, 4)
	end
end

