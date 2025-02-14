local RWFunctions = {};

RWFunctions.Write_Id = buffer.writeu16;

RWFunctions.Read_Id = buffer.readu16;

RWFunctions.Write_Size = buffer.writeu8;

RWFunctions.Read_Size = buffer.readu8;

RWFunctions.getReadFunction = function(size, isStr : boolean?) : any

	local readFunctions = {
		[1] = buffer.readu8;
		[2] = buffer.readu16;
		[4] = buffer.readf32;
		[8] = buffer.readf64;
	}

	local sizeFunction = if readFunctions[size] and not isStr then (function(b,o,c) return readFunctions[size](b,o); end) else (function(b,o,c) return buffer.readstring(b,o,c); end)
	return sizeFunction;

end

return RWFunctions;
