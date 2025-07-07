--[[
Author: Zyos
Date: 7/7/2025 MM/DD/YY
Description: Setup touches (for checkpoints)
IMPORTANT: Use the hyrachie provided in workspace (workspace.ZyosAddons.touches)
]]

local touches = {}
touches.Folder = workspace.ZyosAddons.touches
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

function touches:_setupListeners()
	local startListener = function()
		for i, v in touches.Values["Starts"] do
			v.Touched:Connect(function(hit)
				
			end)
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
