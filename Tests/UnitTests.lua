local UnitTests = {}

local DataManager = require(script.Parent.DataManager)

-- Test that the sum of the array is equal to the correct sum (e.g {1,2,3} should equal 6)
function UnitTests.sumArrayTest(testArray : {number}, sum : number)
	assert(DataManager.sumArr(testArray) == sum, "Array Sum does not Add up to the correct value.")
end

-- Test that the length of the table is correct ({[1] = 3, [4] = 2} should equal 2)
function UnitTests.tableCountTest(testArray : {any}, count : number)
	assert(DataManager.count(testArray) == count, "Array count does not add up to the correct number of elements.")
end

-- Test that the length of the data Size map is correct so all IDs can be mapped correctly
function UnitTests.dataSizeMapLenthTest()
	local dataSizes = DataManager.getDataSizes();
	local sizeMap, _ = DataManager.configureDataSizeMap()
	assert(buffer.len(sizeMap) == DataManager.count(dataSizes) *  (2 + 1), "Data size map is not the correct buffer length")
end

-- Test that the memory address (physical memory address) is correct index ID and size -> physical address.
function UnitTests.getMemoryAddressTest()
	local testMemoryAddress = DataManager.getMemoryAddress(DataManager.dataSizeMap, 3)
	assert(testMemoryAddress == 8, "The getMemoryAddress function found the Incorrect database Index for the ID of 3")
end

-- Test that the write Data function writes the correct number value.
function UnitTests.writeIntDataTest(playerData : buffer)
	local writeValue = 12.34
	DataManager.writeData(playerData, 1, buffer.write32, writeValue)
	assert(DataManager.readData(playerData, 1, false) == writeValue, "Value written is not the same as the value being read at index 1")
end

-- Test that the write data function writes the correct string value
function UnitTests.writeStringDataTest(playerData : buffer)
	local writeValue = "hello"
	DataManager.writeData(playerData, 4, buffer.writestring, writeValue)
	assert(DataManager.readData(playerData, 4, true) == writeValue, "Value written is not the same as the value being read at index 4")
end

return UnitTests
