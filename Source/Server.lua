--!native
-- SERVICES --

local PlayerService = game:GetService("Players");
local RunService = game:GetService("RunService");
local DataStoreService = game:GetService("DataStoreService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- MODULES -- 

local PlayerData = require(script.ServerStore);
local DataManager = require(script.DataManager);
local UnitTests = require(script.UnitTests)

-- CONSTANTS --

local Data_Base : DataStore = DataStoreService:GetDataStore("PLAYERDATA_1");
local SLOT_OFFSET = 4; -- Offset in the DataSizes table (Inventory starts at ID of 4 not 0)

-- EVENTS --

-- Function that will save a cubes position
local function saveCube(player)
	
	local x,y,z = -41.05, 7.45, -13;
	local cubeName = string.format("%-10s", "CUBEEE");
	local r, g, b = 165, 74, 75
	local data = PlayerData[player.UserId];
	
	-- Save the Position
	DataManager.writeData(data, 1, buffer.writef32, x);
	DataManager.writeData(data, 2, buffer.writef32, y);
	DataManager.writeData(data, 3, buffer.writef32, z);
	
	-- Save the Colour
	DataManager.writeData(data, 6, buffer.writeu8, r);
	DataManager.writeData(data, 7, buffer.writeu8, g);
	DataManager.writeData(data, 8, buffer.writeu8, b);
	
	-- Save the name
	DataManager.writeData(data, 4, buffer.writestring, cubeName);
	
end

-- Function that will load a cubes position and colour
local function loadCube(data)
	
	local x,y,z = DataManager.readData(data, 3), DataManager.readData(data, 4), DataManager.readData(data, 5);
	local r,g,b = DataManager.readData(data, 6), DataManager.readData(data, 7), DataManager.readData(data, 8);
	local cubeName = DataManager.readData(data, 9);
	
	print(`Cube_Position_X: {x}`);
	print(`Cube_Position_Y: {y}`);
	print(`Cube_Position_Z: {z}`);
	
	print(`Cube_Colour_R: {r}`);
	print(`Cube_Colour_G: {g}`);
	print(`Cube_Colour_B: {b}`);
	
	print(`Cube_Name: {cubeName}`);
	
	
	
	local cube = Instance.new("Part", workspace)
	cube.Size = Vector3.one * 15;
	cube.Position = Vector3.new(x,y,z);
	cube.Color = Color3.fromRGB(r,g,b);
	cube.Name = cubeName;

end

-- Function that will save the players leaderstats to the database.
local function saveLeaderstats(player)
	local score, level, checkpoint = player.leaderstats.Score.Value, player.leaderstats.Level.Value, player.leaderstats.CheckPoint.Value;
	local data = PlayerData[player.UserId];
	DataManager.writeData(data, 1, buffer.writeu32, score);
	DataManager.writeData(data, 2, buffer.writeu32, level);
	DataManager.writeData(data, 3, buffer.writeu32, checkpoint);
end

-- Add to the inventory slot.
local function addToInventory(slot : number, itemID : number, quantity : number, player : Player)

	local playerData = PlayerData[player.UserId];

	local slotID = DataManager.readData(playerData, (slot * 2) + SLOT_OFFSET - 2, false);
	local oldQuantity = DataManager.readData(playerData, (slot * 2) + SLOT_OFFSET - 1, false);

	print(slotID, oldQuantity)


	if slotID == 0 then
		--write the slotID into the inventory
		DataManager.writeData(playerData, (slot * 2) + SLOT_OFFSET - 2, buffer.writeu16, itemID);
		--write the quantity into the inventory
		DataManager.writeData(playerData, (slot * 2) + SLOT_OFFSET - 1, buffer.writeu8, quantity);

		return true;
	end

	if slotID == itemID and oldQuantity + quantity <= 255 then
		--write the quantity into the inventory
		DataManager.writeData(playerData, (slot * 2) + SLOT_OFFSET - 1, buffer.writeu8, quantity + oldQuantity);
		return true;
	end

	warn("Can't save data to inventory, likely something is already there or slot is full.")
	return false;
end

-- Function that will clear the inventory of the player specified, sets all values to 0.
local function clearInventory(player : Player)
	for slot = 4, 62, 2 do
		
		local playerData = PlayerData[player.UserId];
		
		--write the slotID into the inventory
		DataManager.writeData(playerData, slot, buffer.writeu16, 0);
		--write the quantity into the inventory
		DataManager.writeData(playerData, slot + 1, buffer.writeu8, 0);
	end
end

-- Function that will fire when the player joins the Server.
local playerJoins = function(player : Player)

	print(`{player.Name} joined. Loading data...`);

	local data = Data_Base:GetAsync(`{player.UserId}_DATA`) or DataManager.configureDataBuffer();
	local playerMap = Data_Base:GetAsync(`{player.UserId}_MAP`) or DataManager.dataSizeMap;
	
	data = DataManager.updateData(data, playerMap);
	

	-- CHOOSE YOUR USE CASE HERE
	
	PlayerData[player.UserId] = data;
	
	--ReplicatedStorage.Events.Leaderstats.Setup:Fire(player);
	--addToInventory(4, 23, 22, player);
	--clearInventory(player);
	
	--DataManager.printData(data, playerMap) -- Prints the data in the buffer to the console

end

-- Function that will fire when the player leaves the server
local playerLeaves = function(player : any)
	
	print(`{player.Name} left the game. Saving data...`);
	
	local data = PlayerData[player.UserId];
	
	--DataManager.writeData(data, 1, buffer.writeu32, 1400000); -- WRITES THE XP
	--DataManager.writeData(data, 2, buffer.writeu32, 900); -- WRITES THE LEVEL
	--DataManager.writeData(data, 3, buffer.writeu32, 68); -- WRITES THE CHECKPOINT
	
	
	--CHOOSE YOUR USE CASE HERE
	
	--saveCube(player);
	--saveLeaderstats(player);
	
	Data_Base:SetAsync(`{player.UserId}_DATA`, PlayerData[player.UserId]);
	Data_Base:SetAsync(`{player.UserId}_MAP`, DataManager.dataSizeMap);

end

-- Event connections for client joins/leaves.
PlayerService.PlayerAdded:Connect(playerJoins);
PlayerService.PlayerRemoving:Connect(playerLeaves);

-- Function call for defining the dataSizeMap and dataSize (Size of client record block).
DataManager.dataSizeMap, DataManager.totalDataSize = DataManager.configureDataSizeMap();