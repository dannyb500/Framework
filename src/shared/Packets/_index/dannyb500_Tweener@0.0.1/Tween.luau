--!strict
local TweenService = game:GetService("TweenService")

local Tween = {}
Tween.__index = Tween

--[[
	@public
	@function new()
	@return Signal<T...>
]]

function Tween.new(Object: BasePart, TweenInfo: TweenInfo, Property: {[string]: string})
	assert(Object,"NO OBJECT FOUND TO TWEEN")
	assert(typeof(TweenInfo) ~= "table","NO TWEEN INFO FOUND")
	assert(typeof(Property) == "table","NO PROPERTIES FOUND")
	local T = TweenService:Create(Object,TweenInfo,Property)	
	return T
end

return Tween
