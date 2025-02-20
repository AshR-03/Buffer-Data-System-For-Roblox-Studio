local RWFunctions = {};

RWFunctions.Write_Id = buffer.writeu16; -- The function that writes the ID to the dataSizeMap

RWFunctions.Read_Id = buffer.readu16; -- The function that reads the ID to the dataSizeMap

RWFunctions.Write_Size = buffer.writeu8; -- The function that writes the Size to the dataSizeMap

RWFunctions.Read_Size = buffer.readu8; -- The function that reads the Size to the dataSizeMap

-- Gets the specified function based on the Size of the Allocated memory (reading index 1 with 4 bytes would return buffer.readu32)
RWFunctions.getReadFunction = function(size, isStr : boolean?, readType : string) : any

	local readFunctions = {
		['u'] = {
			[1] = buffer.readu8,
			[2] = buffer.readu16,
			[4] = buffer.readu32,
			[8] = nil;
		},
		['f'] = {
			[1] = buffer.readu8,
			[2] = buffer.readu16,
			[4] = buffer.readu32,
			[8] = buffer.readf64
		},
		['i'] = {
			[1] = buffer.readu8,
			[2] = buffer.readu16,
			[4] = buffer.readu32,
			[8] = nil
		}
	}

	local sizeFunction = if readFunctions[readType][size] and not isStr then (function(b,o,c) return readFunctions[readType][size](b,o); end) else (function(b,o,c) return buffer.readstring(b,o,c); end)
	return sizeFunction;

end

return RWFunctions;
