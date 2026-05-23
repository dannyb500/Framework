--!strict
local TweenService = game:GetService("TweenService")

local Tween = {}
Tween.__index = Tween

--[[
	@public
	@function Model()
	@return Signal<T...>
]]

function Tween:ModelCF(Object: Model, TweenInfo: TweenInfo, EndPosition: CFrame | Vector3,Defer: boolean)
	assert(typeof(TweenInfo) ~= "table","NO TWEEN INFO FOUND")
	local TargetCFrame 

	if typeof(EndPosition) == "Vector3" then
		TargetCFrame = CFrame.new(EndPosition) * Object:GetPivot().Rotation 
	else
		TargetCFrame = EndPosition
	end

	local Value = Instance.new("CFrameValue")
	Value.Value = Object:GetPivot();

	Value:GetPropertyChangedSignal("Value"):Connect(function()
		Object:PivotTo(Value.Value)
	end)

	local T = TweenService:Create(Value,TweenInfo, {Value = TargetCFrame})
	T:Play()
	
	if not Defer then 
		T.Completed:Wait()
	else
		return
	end
end

return Tween
