local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Ins = {}
local Run = {}
local Running = false

local function ParentTo(T:{},Parent)
	for _,v in T do
		if v == Parent then
			continue
		end
		v.Parent = Parent
	end
end

local function Create3dPart(Size:Vector3)
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.CastShadow = false
	Part.Size = Size or vector.create(0.1,0.1,0.1)
	Part.Transparency = 1
	Part.Name = "3dPart"
	Part.Parent = game.Workspace.CurrentCamera
	return Part
end

--[[
Updates 3d object position to fit camera
]]
local function Update(index, v: {BasePart | UDim2},Camera)
	local Object = v[1]
	local ScreenPosition = v[2]
	if not Object or not ScreenPosition then
		table.remove(Run, index)
		return
	end

	local viewportSize = Camera.ViewportSize
	local screenX = ScreenPosition.X.Scale * viewportSize.X + ScreenPosition.X.Offset
	local screenY = ScreenPosition.Y.Scale * viewportSize.Y + ScreenPosition.Y.Offset

	local screenRay = Camera:ScreenPointToRay(screenX, screenY)
	local rayOrigin = screenRay.Origin
	local rayDirection = screenRay.Direction

	local distance = 10
	Object.Position = rayOrigin + rayDirection.Unit * distance
end

local function StartRun()
	if Running then
		return
	end

	Running = true
	RunService:BindToRenderStep("3dGuis", Enum.RenderPriority.Camera.Value + 1, function()
		for i, v in Run do
			Update(i, v,game.Workspace.CurrentCamera)
		end
	end)
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
			Object[Property] = Value
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
			Child.Parent = Parent or Object
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

--[[
Create a 3d gui that attaches to the camera
@param Object: string
@param Properties: table
@param ScreenPosition: UDim2
@param ObjectSize: Vector3
@return Instance
]]
function Ins.new3d(Object :string,Properties :{ Property: string },ScreenPosition :UDim2,ObjectSize :Vector3)
	local Part = Create3dPart(vector.create(.5,1,.1))
	Part.Orientation = vector.create(0,-80,0)
	Part.Size = ObjectSize

	local NewObject = Ins.new(Object,Properties)
	NewObject.Parent = Part
	table.insert(Run,{Part,ScreenPosition or UDim2.new(.5,0,.5,0)})

	StartRun()
	return NewObject
end

return Ins
