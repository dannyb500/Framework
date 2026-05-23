local Signal = require(script.Parent.Parent["dannyb500_Signal"].Signal)
local Maid = require(script.Parent.Parent["dannyb500_GC"].GC)

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
    return {};
end

local Player = game.Players.LocalPlayer
local GUI = Player:WaitForChild("PlayerGui")

local UI = {}
UI.__index = UI;
local function HasProperty(Instance: BasePart, Property: string)
	return pcall(function()
		return Instance[Property]
	end)
end

local function FindStyle(Name: string)
    assert(ReplicatedStorage:FindFirstChild("Design"),`COULD NOT FIND STYLE DESIGN FOLDER`)
    assert(ReplicatedStorage.Design:FindFirstChild(Name),`COULD NOT FIND STYLE SHEET {Name}`)
    return ReplicatedStorage.Design[Name];
end

local function SetStyle(self,SGUI: ScreenGui,Style: StyleSheet)
    if SGUI:FindFirstChildWhichIsA("StyleLink") then
        SGUI:FindFirstChildWhichIsA("StyleLink").StyleSheet = Style;
        return 1;
    end
    local Linker = Instance.new("StyleLink")
    self:ApplyProperties(Linker,{
        Name = Style.Name;
        Parent = SGUI;
        StyleSheet = Style;
    })
end

function UI:ConnectEnum(Instance: UIBase,Type: string,fnc:() -> nil)
    self._Maid:Connect(Instance[Type],fnc)
end

function UI:ForEach(Table: {any}, fnc:() -> ())
	local Array = {};
	for i,v in Table do
		table.insert(Array, fnc(i, v))
	end;
	return Array
end

function UI:ApplyProperties(Instance: BasePart, Properties: {[string]: any})
    for i, v in Properties do
        if HasProperty(Instance,i) then
            if typeof(v) == "function" then
                self:ConnectEnum(Instance,i,v)
            else
                Instance[i] = v;
            end
        end
        if i == "Tag" then
            CollectionService:AddTag(Instance,v);
        end
    end
    return;
end


function UI.new()
    local ScreenGui = Instance.new("ScreenGui",GUI);
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local self = setmetatable({},UI);
    self.Screen = ScreenGui;

    self.Enum = {
        Activated = "MouseButton1Click";
        Enter = "MouseEnter";
		Leave = "MouseLeave";
		PropertyChanged = "GetPropertyChangedSignal"
    };

    self._Style = nil;

    self._Maid = Maid.new();
    self._Signal = Signal.new();
	self._Parent = self.Screen;
	self._CurrentParent = self._Parent;
	
    return self
end

function UI:LoadStyleSheet(StyleSheet: string)
    self._Style = FindStyle(StyleSheet);
    SetStyle(self,self.Screen,self._Style)
end

function UI:LinkClass(Class: string)
    
end

function UI:CreateElement(Object: string,Properties: {any}, Children: {})
    local Ins = Instance.new(Object);
	self:ApplyProperties(Ins,Properties);
    
    Ins.Parent = self._Parent;
	self._CurrentParent = Ins
    
    if not Children then
        return Ins;
    end
    for i, v: {} in Children do
		if typeof(v) == "table" then
			if v["Instance"] then
				v.Instance.Parent = Ins;
				continue
			end
			for _,k in v do
				k.Instance.Parent = Ins
			end
		end
        if typeof(v) ~= "Instance" then
            continue;
		end
		print(v)
		v.Parent = Ins;
    end
	self._CurrentParent = Ins

	return {
		Instance = Ins;
		mount = function(self, meta: {})
			Ins.Parent = if not meta then self.Instance else meta.Instance;
			return self
		end,
	}
end

function UI:Destroy()
    self.Screen:Destroy();
    self._Maid:Destroy();

end

return UI