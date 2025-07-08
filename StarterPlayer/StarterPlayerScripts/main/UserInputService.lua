--[[
Author: Zyos
Date: 07/08/2025 DD/MM/YY
Description: Handles UserInputService and fires Events
]]

--Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Events
local UserInputServiceEvents = ReplicatedStorage:WaitForChild("ZyosAddons"):WaitForChild("UserInputService")

local Bindable = UserInputServiceEvents:WaitForChild("Bindable")
local Remote = UserInputServiceEvents:WaitForChild("Remote")

--Settings 
local S_INPUTTABLE = {"r"}

--XX--

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	
	if table.find(S_INPUTTABLE, input.KeyCode.Name:lower()) then
		Bindable:Fire(input.KeyCode.Name:lower())
		Remote:FireServer(input.KeyCode.Name:lower())
		print(input.KeyCode.Name:lower())
	end
end)