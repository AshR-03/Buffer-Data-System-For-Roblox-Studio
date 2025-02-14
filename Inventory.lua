-- MODULES --

local PlayerData = require(script.Parent.Server.ServerStore);
local DataManager = require(script.Parent.Server.DataManager);

-- CONSTANTS --

local SLOT_OFFSET = 3; -- Offset in the DataSizes table (Inventory starts at ID of 4 not 0)

-- FUNCTIONS --

-- Add to the inventory slot.
local function addToInventory(slot : number, itemID : number, quantity : number, player : Player)
	
	local playerData = PlayerData[player.UserId];
	
	local slotID = DataManager.readData(playerData, slot + SLOT_OFFSET, false);
	local oldQuantity = DataManager.readData(playerData, slot + SLOT_OFFSET + 1, false);
	
	if slotID == 0 then
		--write the slotID into the inventory
		DataManager.writeData(playerData, slot + SLOT_OFFSET, buffer.writeu16, itemID);
		--write the quantity into the inventory
		DataManager.writeData(playerData, slot + SLOT_OFFSET + 1, buffer.writeu8, quantity);
		
		return true;
	end
	
	if slotID == itemID and oldQuantity + quantity <= 255 then
		--write the quantity into the inventory
		DataManager.writeData(playerData, slot + SLOT_OFFSET + 1, buffer.writeu8, quantity + oldQuantity);
		return true;
	end
	
	warn("Can't save data to inventory, likely something is already there or slot is full.")
	return false;
end

