--[[
Author: Zyos
Date: 07/07/2025 DD/MM/YY
Description: Manages data
]]

--Services
local DSS = game:GetService("DataStoreService")

--Modules
local dataTree = require(script.dataTree)

--XXX--

local data_ = {}

--Initialize player
function data_:setup(plr)
	local data = data_:_loadPlayerData(plr)

	for i, folder in dataTree.Folders do
		data_:_createFolder(plr, folder, data)
	end
end

--Load player data
function data_:_loadPlayerData(plr)
	if not dataTree.DataStoreName then return end

	local success, result = pcall(function()
		return DSS:GetDataStore(dataTree.DataStoreName):GetAsync(plr.UserId)
	end)

	return success and result or {}
end

--Create player data folders
function data_:_createFolder(plr, folderDef, data)
	local newFolder = Instance.new("Folder")
	newFolder.Name = folderDef.Name
	newFolder.Parent = plr

	for i, value in folderDef.Values do
		data_:_createValue(value, newFolder, data)
	end
end

--Create player data values
function data_:_createValue(valueDef, newFolder, data)
	local value = Instance.new(valueDef.Instance)
	value.Name = valueDef.Name

	if data and valueDef.Save and data[valueDef.Name] then
		value.Value = data[valueDef.Name]
	else
		value.Value = valueDef.StartValue
	end

	value.Parent = newFolder
end

--Save data
function data_.dataSave(plr)
	if not dataTree.DataStoreName then return end

	local ds = DSS:GetDataStore(dataTree.DataStoreName)
	local saveData = data_:_collectSaveData(plr)

	local success, err = pcall(function()
		ds:SetAsync(plr.UserId, saveData)
	end)

	if not success then
		warn("Save failed for", plr.Name, err)
	end

	task.wait()
end

--Collect data to save
function data_:_collectSaveData(plr)
	local saveData = {}

	for _, child in plr:GetChildren() do
		local folderDef = data_:_getFolderDefinitionByName(child.Name)
		if not folderDef then continue end

		local valuesToSave = data_:_getValuesToSave(child, folderDef)
		if not valuesToSave then continue end

		for key, value in valuesToSave do
			saveData[key] = value
		end
	end

	return saveData
end

--Check if the folder is in the dataTree
function data_:_getFolderDefinitionByName(name)
	for _, folder in dataTree.Folders do
		if folder.Name == name then
			return folder
		end
	end
	return nil
end

--Get values which needs to be saved
function data_:_getValuesToSave(child, folderDef)
	local result = {}

	for _, valueDef in folderDef.Values do
		if not data_:_shouldSaveValue(child, valueDef) then return end

		result[valueDef.Name] = child[valueDef.Name].Value
	end

	return result
end

--Check if value needs to be saved
function data_:_shouldSaveValue(child, valueDef)
	return valueDef.Save and child:FindFirstChild(valueDef.Name)
end

return data_