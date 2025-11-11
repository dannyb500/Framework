local RunService = game:GetService("RunService")
local Tags = game:GetService("CollectionService")

local Wires = nil;

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Client = {
	Name = script.Name,
	MAX_DIST = 10;
}

local ClosestDoor = nil;
local CharPos;

local BOX_SIZE = .6;

local DOOR_CACHE = {}

local function DoorRender()
	CharPos = Character:GetPivot().Position;

	for i,Door in DOOR_CACHE do	
		local DoorPos = Door:GetPivot().Position;
		local Dist = (CharPos - DoorPos).Magnitude;
	
		if Dist <= Client.MAX_DIST then
			ClosestDoor = Door;
            Wires:DrawBoxOutline(DoorPos,BOX_SIZE,CharPos);
			Wires:DrawLine(DoorPos,CharPos)
			Wires:DrawText(DoorPos + Vector3.new(0,-1,0),20,"[E] TO OPEN DOOR")
		end
	end
end

function Client:Start()
    Wires = self._index.Wire
    Wires:SetColor("w")

	for _,Door in Tags:GetTagged("Door") do
		table.insert(DOOR_CACHE,Door)
	end
	
	Tags:GetInstanceAddedSignal("Door"):Connect(function(Door: Model)
		table.insert(DOOR_CACHE,Door)
	end)
	
	Tags:GetInstanceRemovedSignal("Door"):Connect(function(Door: Model)
		table.remove(DOOR_CACHE,table.find(Door))
	end)
	
	RunService:BindToRenderStep("DoorWires",1,DoorRender)
	
	Player.CharacterAdded:Connect(function(Char: Model)
		Character = Char
	end)

	local Keyboard = self._index.Input.Keyboard.new()
	local DisconnectSignal = self._index.Signal.new();
	local ResultSignal = self._index.Signal.new();

	ResultSignal:Connect(function(B: boolean)
		warn(B)
	end)

	Keyboard.KeyDown:Connect(function(Key: Enum.KeyCode)
		if Key ~= Enum.KeyCode.E then
			return
		end
		if ClosestDoor and CharPos then
			Wires:FillBoxAnimation(ClosestDoor:GetPivot().Position,BOX_SIZE,Character,DisconnectSignal,ResultSignal)
		end
		return
	end)
	Keyboard.KeyUp:Connect(function(Key: Enum.KeyCode)
		if Key ~= Enum.KeyCode.E then
			return
		end
		DisconnectSignal:Fire()
	end)


end

return Client