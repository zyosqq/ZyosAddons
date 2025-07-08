--[[
Author: Zyos
Date: 07/08/2025 DD/MM/YY
Description: Handles Reset Button
Uses: UserInputService
]]

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--Events
local UserInputServiceEvents = ReplicatedStorage:WaitForChild("ZyosAddons"):WaitForChild("UserInputService")

local Bindable = UserInputServiceEvents:WaitForChild("Bindable")

--Variables
local player = Players.LocalPlayer

--Settings 

--XX--

Bindable.Event:Connect(function(key)
	if key == "r" then
		local pCFrames = player:WaitForChild("CFrames")
		local currentCFrame = pCFrames:WaitForChild("currentCFrame")
		local spawnCFrame = pCFrames:WaitForChild("spawnCFrame")
		
		if currentCFrame.Value == CFrame.new() then
			player.Character:PivotTo(spawnCFrame.Value)
			return
		end

		player.Character:PivotTo(currentCFrame.Value)
	end
end)