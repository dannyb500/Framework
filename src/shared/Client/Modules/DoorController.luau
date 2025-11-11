local RunService = game:GetService("RunService")
local Tags = game:GetService("CollectionService")

local Wires = nil;

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Client = {
	Name = script.Name,
	MAX_DIST = 10;
}

local DOOR_CACHE = {}

local function DoorRender()
	for i,Door in DOOR_CACHE do
		local DoorPos = Door:GetPivot().Position;
		local CharPos = Character:GetPivot().Position;
		local Dist = (CharPos - DoorPos).Magnitude;
		-- if Dist <= Client.MAX_DIST then
            print(i)
            if i == 1 then
                Wires:SetColor(Color3.fromRGB(255,0,0))
            end
            if i == 2 then
                Wires:SetColor(Color3.fromRGB(0,255,0))
            end
			Wires:DrawLine(DoorPos,CharPos)
			Wires:DrawText(DoorPos,"[E] TO OPEN DOOR")
		-- end
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
end

return Client