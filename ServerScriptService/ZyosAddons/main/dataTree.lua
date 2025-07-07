--[[
Author: Zyos
Date: 07/07/2025 DD/MM/YY
Description: Manages data for players
IMPORTANT: This needs to be a child of data_.lua
]]

local dataTree = {}

local dataTree = {
	["DataStoreName"] = "Test_0",
	["Folders"] = {
		[1] = {
			["Name"] = "leaderstats",
			["Values"] = {
				[1] = {
					["Instance"] = "NumberValue",
					["StartValue"] = 0,
					["Save"] = true,
					["Name"] = "temp"
				},
			}
		},
		[2] = {
			["Name"] = "spawn",
			["Values"] = {
				[1] = {
					["Instance"] = "CFrameValue",
					["StartValue"] = CFrame.new(),
					["Save"] = false,
					["Name"] = "currentCFrame"
				},
				[2] = {
					["Instance"] = "CFrameValue",
					["StartValue"] = CFrame.new(),
					["Save"] = false,
					["Name"] = "spawnCFrame"
				},
			}
		}

	}
}	

return dataTree
