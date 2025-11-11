local Mod = {}
--// PLAYER RELATED FUNCTIONS \\--

--[[
Sets a Attribute Named "InGame" to a value
@param Boolean?
]]
function Mod.SetInGame(value)
	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			v.Character:SetAttribute("InGame", value)
		end
	end
end

--[[
Teleport a Player to a CFrame
@param Player; Location: CFrame
]]
function Mod.Teleport(plr: Player, loc: CFrame)
	if plr.Character then
		plr.Character.HumanoidRootPart:PivotTo(loc)
	end
end

--[[
Teleports all Players to a CFrame
@param Location: CFrame
]]
function Mod.TeleportAllPlayers(loc: CFrame)
	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			v.Character.HumanoidRootPart.CFrame = loc
		end
	end
end

--[[
Team a player to a Team inside Teams
@param Player; TeamName: string
@return nil
]]
function Mod.Team(plr, TeamName)
	plr.Team = game.Teams[TeamName]
end

--[[
Teams all players to a Team inside Teams
@param TeamName: string
@return nil
]]
function Mod.TeamAllPlayers(Team: string)
	for _, v in pairs(game.Players:GetPlayers()) do
		if v and Team then
			if type(Team) == "string" then
				v.Team = game.Teams[Team]
			else
				v.Team = Team
			end
		end
	end
end

--[[
Create a team that goes into teams;
@param TeamName: string; TeamColor: BrickColor
@return Team: team
]]
function Mod.CreateTeam(TeamName, Color)
	if game.Teams:FindFirstChild(TeamName) then
		game.Teams[TeamName]:Destroy()
	end
	local Team = Instance.new("Team")
	Team.Name = TeamName
	Team.AutoAssignable = false
	Team.Parent = game.Teams
	Team.TeamColor = Color or BrickColor.Red()
	return Team
end

--[[
Remove a team from teams;
@param TeamName: string
@return nil
]]
function Mod.RemoveTeam(TeamName)
	if game.Teams:FindFirstChild(TeamName) then
		game.Teams[TeamName]:Destroy()
	end
end

--[[
Remove all teams from teams;
@return nil
]]
function Mod.RemoveAllTeams()
	for _, v in pairs(game.Teams:GetChildren()) do
		if v.Name ~= "Intermission" then
			v:Destroy()
		end
	end
end

--[[
Removes all Accessories from every player
]]
function Mod.RemoveAccessories()
	for _, v in pairs(game.Players:GetPlayers()) do
		for _, char in pairs(v:GetDescendants()) do
			if char:IsA("Accessory") then
				char:Destroy()
			end
		end
	end
end

--[[
Kicks all players from the game
]]
function Mod.KickAllPlayers()
	for _, v in pairs(game.Players:GetPlayers()) do
		v:Kick("Server has been shutdown")
	end
end

--[[
Resets all players
LoadsCharacter
]]
function Mod.ResetPlayers()
	for _, v in pairs(game.Players:GetChildren()) do
		if v.Character then
			v:LoadCharacter()
		end
	end
end

--[[
CLIENT USE
Hide players character
@param Player; Value: number 1-0 | UnassignedValue: 1
@return nil
]]
function Mod.HidePlayer(plr,Value)
	local PlrCharacter = plr.Character
	for _, v in pairs(PlrCharacter:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("MeshPart") then
			v.Transparency = Value or 1
		elseif v:IsA("Accessory") then
			v:Destroy()
		end
	end
	if PlrCharacter:FindFirstChildWhichIsA("Model") then
		PlrCharacter:FindFirstChildWhichIsA("Model"):Destroy()
	end
end

--[[
Welds a model to the PrimaryPart
]]
function Mod.Weld(Model)
	local Descendants = Model:GetDescendants()
	for _, v in Descendants do
		if not v:IsA("BasePart") then
			continue	
		end
		v.Anchored = false
		v.CanCollide = false
		local Weld = Instance.new("WeldConstraint")
		Weld.Part1 = v
		Weld.Part0 = Model.PrimaryPart or Descendants[1]
		Weld.Parent = Model.PrimaryPart or Descendants[1]
	end
end

--[[
Weld one part to another part
@return WeldConstraint
]]
function Mod.WeldTo(PointA,PointB)
	local Weld = Instance.new("WeldConstraint")
	Weld.Part1 = PointA
	Weld.Part0 = PointB
	Weld.Parent = PointA
	return Weld
end


--[[
	Clears all GUI except for any ui names Main
]]
function Mod.ClearAllUI()
	for _,v in pairs(game.Players:GetPlayers()) do
		for _,ui in pairs(v.PlayerGui:GetChildren()) do
			if ui.Name:match("Main") then
				ui:Destroy()
			end
		end
	end
end

--[[
	Clear GUI which matches name
	@param uiName:string
	@return nil
]]
function Mod.ClearUI(uiName:string)
	for _,v in pairs(game.Players:GetPlayers()) do
		for _,ui in pairs(v.PlayerGui:GetChildren()) do
			if ui.Name:match(uiName) then
				ui:Destroy()
			end
		end
	end
end

function Weld(Model,WeldTo)
	for i,v in pairs(Model:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored   = false
			v.CanCollide = false

			local Weld   = Instance.new("WeldConstraint")
			Weld.Part1   = v
			Weld.Part0   = WeldTo
			Weld.Parent  = WeldTo
		end
	end
end


--[[

]]
function Mod.NewWeld(Model,To,WeldTo)
	Weld(Model,WeldTo or Model.Middle)
	local Weld = Instance.new("Weld") 
	Weld.Part0 = To
	Weld.Part1 = WeldTo or Model.Middle
	Weld.Parent = To
	Model.Parent = To
end

--[[
@param Item
]]
function Mod.Reclass(Item,NewClass)
	local New = Instance.new(NewClass) 
	if not New then return end

	for i,v in pairs(Item:GetChildren()) do
		v.Parent = New
	end
	New.Parent = Item.Parent
	Item:Destroy()
	return New

end


return Mod