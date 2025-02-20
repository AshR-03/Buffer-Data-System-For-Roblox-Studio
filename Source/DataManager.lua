--!native
-- MODULES --

local RWFunctions = require(script["R/W_Functions"]);

-- CONSTANTS --

local Size_Length : number = 1;

local Id_Length : number = 2;

local DM = {}

--Variables --

DM.totalDataSize = 0;

DM.dataSizeMap = nil;


DM.printMap = function(b:buffer)
	local offset = 0
	local id = 0;
	local mapSize = Size_Length + Id_Length;
	while offset < buffer.len(b) do
		print(RWFunctions.Read_Id(b, id * mapSize), RWFunctions.Read_Size(b, (id * mapSize) + Id_Length));
		offset += mapSize;
		id += 1;
	end
end

DM.sumArr = function(tbl) : number
	local total = 0;
	for _, v in pairs(tbl) do
		total += v;
	end
	return total;
end

DM.count = function(tbl) : number
	local total = 0;
	for _, v in pairs(tbl) do
		total += 1;
	end
	return total;
end

DM.getDataSizes = function() : {[number] : number}

	-- EDIT THESE SIZES TO MATCH YOUR DATA.
	local dataSizes = { 			-- (ID = SIZE)
		[1] = 4;					-- XP
		[2] = 4;					-- LEVEL
		[3] = 4;					-- CHECKPOINT
		
		-- INVENTORY (30 Slots) ID 4 - 64
		
	}
	
	for i = 4, 62, 2 do -- Allocating IDs 4 - 64 to the Inventory Slots
		dataSizes[i] = 2; -- ID for the ITEM (MAX 65536 unique items)
		dataSizes[i+1] = 1; -- ID for the QUANITITY (MAX 256 items)
	end

	return dataSizes;
end

DM.configureDataSizeMap = function() : (buffer, number)
	local dataSizes = DM.getDataSizes();
	local sizeMapBuffer : buffer = buffer.create(DM.count(dataSizes) *  (Id_Length + Size_Length));

	local offset = 0;
	for i = 1, table.maxn(dataSizes) do
		if dataSizes[i] == nil then continue end;
		RWFunctions.Write_Id(sizeMapBuffer, offset, i);
		offset += Id_Length;
		RWFunctions.Write_Size(sizeMapBuffer, offset, dataSizes[i]);
		offset += Size_Length;
	end
	return sizeMapBuffer, DM.sumArr(dataSizes);
end

DM.configureDataBuffer = function() : (buffer)
	return buffer.create(DM.totalDataSize);
end

DM.getMemoryAddress = function(map : buffer, idToFind : number) : (any, any)
	-- GETS THE ADDRESS OF THE SPECIFIED ID
	local address = 0;
	local offset = 0;
	local mapSize = Size_Length + Id_Length;
	while offset < buffer.len(map) do
		local id = RWFunctions.Read_Id(map, offset);
		offset += Id_Length;
		local count = RWFunctions.Read_Size(map, offset);
		--print(id, "id", ",", idToFind, "Id to find")

		if id == idToFind then return address, count end;

		address += count;
		offset += Size_Length;
	end
	return nil, nil;
end

DM.writeData = function(b : buffer, id : number, f : any, data : number | string)
	
	print(`Writing {data} to {id}`)
	
	local address, count = DM.getMemoryAddress(DM.dataSizeMap, id);
	print(address, count)	
	
	f(b, address, data);
end

DM.readData = function(b : buffer, id : number, isStr : boolean, readType : string) : any
	local address, count = DM.getMemoryAddress(DM.dataSizeMap, id);
	if address then return RWFunctions.getReadFunction(count, isStr, readType or 'u')(b, address, count) end;
	return false;
end

DM.printData = function(b:buffer, map:buffer)
	local dataSizes = DM.getDataSizes();
	for id = 1, table.maxn(dataSizes) do
		if DM.getMemoryAddress(map, id) then
			print(DM.readData(b, id));
		end
	end
end

DM.updateData = function(oldData: buffer, oldMapping: buffer) : ()
	local newData = DM.configureDataBuffer();

	for id = 1, table.maxn(DM.getDataSizes()) do

		local oldAddress, oldCount = DM.getMemoryAddress(oldMapping, id);
		local newAddress, newCount = DM.getMemoryAddress(DM.dataSizeMap, id);

		if not newAddress then continue end;
		if not oldAddress then continue end;
		if newCount ~= oldCount then continue end;

		buffer.copy(newData, newAddress, oldData, oldAddress, newCount);

	end                                                                       
	return newData;
end

return DM;
