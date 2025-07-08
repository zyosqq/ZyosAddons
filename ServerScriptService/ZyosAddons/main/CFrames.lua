--[[
Author: Zyos
Date: 7/7/2025 MM/DD/YY
Description: Reset / Spawn player
Uses: data_
]]

local CFrames = {}

function CFrames:spawn(player)
	local pCFrames = player:WaitForChild("CFrames")
	local spawnCFrame = pCFrames:WaitForChild("spawnCFrame")
	
	player.Character:PivotTo(spawnCFrame.Value)
end

function CFrames:reset(player)
	local pCFrames = player:WaitForChild("CFrames")
	local currentCFrame = pCFrames:WaitForChild("currentCFrame")
	
	if currentCFrame.Value == CFrame.new() then
		self:spawn(player)
		return
	end

	player.Character:PivotTo(currentCFrame.Value)
end

function CFrames:set(player, CFrame_, heigtAddon)
	local pCFrame = player:WaitForChild("CFrames")
	local currentCFrame = pCFrame:WaitForChild("currentCFrame")
	
	if heigtAddon then
		currentCFrame.Value = CFrame_ * CFrame.new(0,5,0)
		return
	end
	
	currentCFrame.Value = CFrame_
end

return CFrames