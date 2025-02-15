local UnitTests = {}

local DataManager = require(script.Parent.DataManager)


function UnitTests.sumArrayTest(testArray : {number}, sum : number)
	assert(DataManager.sumArr(testArray) == sum, "Array Sum does not Add up to the correct value.")
end

function UnitTests.tableCountTest(testArray : {any}, count : number)
	assert(DataManager.count(testArray) == count, "Array count does not add up to the correct number of elements.")
end

function UnitTests.dataSizeMapLenthTest()
	local dataSizes = DataManager.getDataSizes();
	local sizeMap, _ = DataManager.configureDataSizeMap()
	assert(buffer.len(sizeMap) == DataManager.count(dataSizes) *  (2 + 1), "Data size map is not the correct buffer length")
end

function UnitTests.getMemoryAddressTest()
	local testMemoryAddress = DataManager.getMemoryAddress(DataManager.dataSizeMap, 3)
	assert(testMemoryAddress == 8, "The getMemoryAddress function found the Incorrect database Index for the ID of 3")
end

function UnitTests.writeIntDataTest(playerData : buffer)
	local writeValue = 12.34
	DataManager.writeData(playerData, 1, buffer.write32, writeValue)
	assert(DataManager.readData(playerData, 1, false) == writeValue, "Value written is not the same as the value being read at index 1")
end

function UnitTests.writeStringDataTest(playerData : buffer)
	local writeValue = "hello"
	DataManager.writeData(playerData, 4, buffer.writestring, writeValue)
	assert(DataManager.readData(playerData, 4, true) == writeValue, "Value written is not the same as the value being read at index 4")
end

return UnitTests
