local Ins = {}

local function ParentTo(T:{},Parent)
	for _,v in T do
		if v == Parent then
			continue
		end
		v.Parent = Parent
	end
end

local function HasProperty(Instance: BasePart,Property: string,Value: any)
	local success,_ = pcall(function()
		return Instance[Property]
	end)
	return success;
end

function Ins:ApplyProperties(Object: {Connect: () -> ()},Properties: {Property: string},Parent)
	assert(Object,"Object is nil")
	assert(typeof(Properties) == "table","Properties is not a table")

	for Property,Value in Properties do
		if Property ~= "Children" and Property ~= "BindEvent" then
			if typeof(Value) == "function" then
				task.defer(function()
					Value(Object)
				end)
				continue
			end
			if HasProperty(Object,Property) then
				Object[Property] = Value
			end
			continue	
		end
		if Property == "BindEvent" then
			for EventName, Callback in Value do
				if Object[EventName] and typeof(Object[EventName].Connect) == "function" then
					Object[EventName]:Connect(function()
						Callback(Object)
					end)
				else
					warn("Invalid event: " .. EventName)
				end
			end
			continue
		end
		for _,Child in Value do
			Child.Parent = if Parent then Parent else Object
			if typeof(Child) == "table" then
				ParentTo(Child,Object)
			end
		end
	end
end

function Ins:BindEvents(Object: {Connect: () -> ()}, Events: {[string]: () -> ()})
	assert(Object, "Object is nil")
	assert(typeof(Events) == "table", "Events is not a table")

	for EventName, Callback in Events do
		if Object[EventName] and typeof(Object[EventName].Connect) == "function" then
			Object[EventName]:Connect(function()
				Callback(Object)
			end)
		else
			warn("Invalid event: " .. EventName)
		end
	end
end

function Ins.new(Object:string, Properties: {[string]: any})
	assert(Object,"Object is nil")

	local NewObject = Instance.new(Object)

	if NewObject and Properties then
		Ins:ApplyProperties(NewObject,Properties)
	end

	return NewObject
end

return Ins
