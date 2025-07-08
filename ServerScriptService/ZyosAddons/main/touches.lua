--[[
Author: Zyos
Date: 7/7/2025 MM/DD/YY
Description: Setup touches (for checkpoints)
IMPORTANT: Use the hyrachie provided in workspace (workspace.ZyosAddons.touches)
Uses: CFrames
]]

--Modules
local CFrames = require(script.Parent.CFrames)

--Settings
local S_FOLDER = workspace.ZyosAddons.touches

--XXX--

local touches = {}

touches.Folder = S_FOLDER
touches.Values = {
	["Starts"] = {},
	["Ends"] = {},
	["Checkpoints"] = {},
	["Connections"] = {
		["Starts"] = {},
		["Ends"] = {},
		["Checkpoints"] = {}
	}
}

function touches:setup(player)
	for i, v in ipairs(touches.Folder:GetDescendants()) do
		if v:FindFirstChild("Start") then table.insert(touches.Values["Starts"], v) end
		if v:FindFirstChild("End") then table.insert(touches.Values["Ends"], v) end
		
		if v:FindFirstChild("C_ACTIVE") then self:_setupCheckpoints(v:GetChildren()) end
	end

	self:connect()
end

function touches:_setupCheckpoints(cFolder)
	for i, v in cFolder do
		if v:IsA("BasePart") and v.cValue then
			table.insert(touches.Values["Checkpoints"], v)
		end
	end
end

function touches:connect()
	local copy = table.clone(self.Values)
	
	self:disconnect()

	for key, partGroup in pairs(copy) do
		if self.Values["Connections"][key] then
			self:_loopPartGroup(key, partGroup)
		end
	end
end

function touches:_loopPartGroup(key, partGroup)
	for _, part in ipairs(partGroup) do
		if part:IsA("BasePart") then
			local conn = part.Touched:Connect(function(hit)
				self:_onTouch(hit, part)
			end)
			table.insert(self.Values["Connections"][key], conn)
		end
	end
end

function touches:_onTouch(hit, part)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end
	
	if part.Parent.Name == "cFolder" then
		if not self:_checkCValue(player, part) then return end
		
		local ID = part.Parent.Parent.ID.Value
		if player.touches.ID.Value ~= ID then return end
		
		player.touches.cValue.Value = part.cValue.Value
		
		CFrames:set(player, part.CFrame)
		return
	end
	
	if part:FindFirstChild("Start") then
		local ID = part.Parent.ID.Value
		if player.touches.ID.Value == ID then return end
		
		player.touches.ID.Value = ID
		
		CFrames:set(player, part.CFrame)
		return
	end
	
	player.touches.cValue.Value = 0
	player.touches.ID.Value = 0
	player.CFrames.currentCFrame.Value = CFrame.new()
	CFrames:spawn(player)
end

function touches:_checkCValue(player, part)
	local cValue = part.cValue
	local plrCValue = player.touches.cValue
	
	if cValue.Value <= plrCValue.Value then return false end
	return true
end

function touches:disconnect()
	for _, connGroup in pairs(self.Values["Connections"]) do
		for _, conn in ipairs(connGroup) do
			if typeof(conn) == "RBXScriptConnection" and conn.Connected then
				conn:Disconnect()
			end
		end
	end

	self.Values["Connections"] = {
		["Starts"] = {},
		["Ends"] = {},
		["Checkpoints"] = {}
	}
end

return touches