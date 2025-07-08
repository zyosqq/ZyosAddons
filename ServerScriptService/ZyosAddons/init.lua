--[[
Author: Zyos
Date: 7/7/2025 MM/DD/YY
Description: Setup Serverside
]]

--Services
local Players = game:GetService("Players")

--Modules
local main =  script.Parent.main --Main Logic

local data_ = require(main.data_)
local touches = require(main.touches)

--Settings
local S_DATA = true
local S_TRAILS = true

--XXX--

--Load Player Data / Setup Player Data
Players.PlayerAdded:Connect(function(player)
	if S_DATA then data_:setup(player) end
end)

--Save Player Data
Players.PlayerRemoving:Connect(function(player)
	if S_DATA then data_.dataSave(player) end
end)

--Setup Touches
if S_TRAILS then touches:setup() end