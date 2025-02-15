# Byte-based Buffer Storage System Module in Lua

This project showcases the effective manipulation of memory blocks to construct a Database system that can solve the problem of  [table](https://create.roblox.com/docs/reference/engine/libraries/table) memory overhead. Utilising [buffers](https://create.roblox.com/docs/reference/engine/libraries/buffer) for byte manipulation, we can significantly reduce the overhead in database systems commonly use in popular Roblox games.

### This Project solves the following problems:

- Remove table overhead whilst stored in [**heap memory**.](https://create.roblox.com/docs/studio/optimization/memory-usage#luau-heap) using byte manipulation rather than tables.
- Reduced database **memory usage** per record ensuring more records can be stored.
- Efficient ID **indirect addressing** and **block allocation** for fast record access.

## Table of Contents
- [Introduction](#project-details)
- [Installation](#local-project-installation-and-use)
- [Included Examples](#included-project-examples)
  - [Client Statistic System](#client-stat-system-use)
  - [Client Inventory System](#client-inventory-use)

## Project Details

A quick look into the Luau heap memory used in Roblox Studio reveals a larger overhead carried with using **Tables** in comparison to **Buffers**.

![image](https://github.com/user-attachments/assets/6d312755-3a44-453e-83a9-3e4500bfb64b)  
*Figure 1: Heap memory usage (in Bytes) from constructing a 25B Table with memory category "TABLE" (448B) and Buffer with memory category "BUFFER". (33B)*  

Therefore, storing large volumes of Player Data on the **Server** can become costly. To resolve this problem, I propose a solution which manages, stores and manipulates client data, whilst only utilising the Buffer type.

**A more detailed explanation** can be found in the project youtube video:

[![A NEW way to SAVE PLAYER DATA In Roblox Studio](https://img.youtube.com/vi/ArnSFrDSJvE/mqdefault.jpg)](https://www.youtube.com/watch?v=ArnSFrDSJvE)

[**A NEW way to SAVE PLAYER DATA In Roblox Studio**](https://www.youtube.com/watch?v=ArnSFrDSJvE&t=0s)

## Local Project Installation and Use

 - Download and open the `projectFile.rbxl` file from this repository from your local computer. `ServerScriptService` will contain the code required to run the data module.
 - Copy the folder containing the package, and paste it into `ServerScriptService` of your Current Roblox Studio Environment.
 - To Save the required data, edit the `DataManager` module script's DataSizes Table. This table is **never stored** in heap memory for an extended span.
   
   ```lua
   local dataSizes = {
       [1] = 1 -- Allocates 1 Byte of memory to the ID of 1.
       [2] = 2 -- Allocates 2 Bytes of memory to the ID of 2.
       [4] = 10 -- Allocates 10 Bytes of memory to the ID of 4.
   }
   ```

   The `dataSizes` table allows the database administrator (DBA) to insert and remove new blocks of memory to each client's allocated memory in the database. In the code snippet above, we allocate 1 Byte (storing 1 character or 1 8 bit number) to the index ID of 1.

- Once the dataSizes schema has been initialised by the DBA, we can start to **read** and **write** data using the specified functions below. To access these functions, the following code is required:

  ```lua
   local DataManager = require(ServerScriptService.AshRBX_DataStoreSystem.Server.DataManager)
   ```
   The read and write functions are now accessible and are defined below:

   ```lua
   DataManager.writeData(playerData, 1, buffer.writeu8, 200) -- Writes the value of 200 using the write unsigned 8 bit integer into the memory location at Index 1. (We allocated 1 Byte to index 1 in dataSizes)
   ```

   The **writeData** function allows for you to specify which client record to write to, the indirect address of the record (index ID), the function used to write the data and the value to save in the format
  `writeData(clientData : buffer, indirectAddress : number, bufferFunction : (any) -> (any), value : number | string)`

   ```lua
   DataManager.readData(playerData, 1, false) -- Reads the value stored at the memory address of index 1, the read function reads the whole range of values based on the size given in dataSizes.
   ```
   The **readData** function allows for you to specify which client record to write to, the indirect address of the record (index ID) and whether you are reading a string or not in the format
   `readData(clientData : buffer, indirectAddress : number, isString : boolean)`

## Included Project Examples

The project includes some **worked examples** to get a new user started with the system. This includes a `Client Stat System` and a `Client Inventory System`.

### Client Stat System Use

  - For the `Client Statistic System`, we will store the Client's `Score`, `Level` and `Checkpoint` and display the results to the user using [**Leaderstats**](https://devforum.roblox.com/t/how-to-make-leaderstats-in-roblox-studio-for-beginners/1856471)
  - Configure the `dataSizes` table to match the following:

    ```lua
    local dataSizes = {
        [1] = 4 -- Allocates 4 Byte of memory to the ID of 1 for SCORE.
        [2] = 4 -- Allocates 4 Bytes of memory to the ID of 2 for LEVEL.
        [3] = 4 -- Allocates 4 Bytes of memory to the ID of 3 for CHECKPOINT.
    }
    ```
   - Move to the `Server.lua` script, and find the `local playerJoins = function(player : Player)` function. This function fires when the Client joins the Server. **uncomment** the following line in the function:

     ```lua
     ReplicatedStorage.Events.Leaderstats.Setup:Fire(player);
     ```
     This code will fire a [Bindable Event](https://create.roblox.com/docs/reference/engine/classes/BindableEvent) which will fire a function inside of `LeaderStat.lua`, displaying the relevant data.

   - Inside of `Server.lua`, find the `local playerLeaves = function(player : any)` function. This function fires when the Client leaves the Server. **uncomment** the following line in the function:

     ```lua
     saveLeaderstats(player);
     ```
     This code will **save the data** into the correct **memory blocks**.
     
### Client Inventory Use

  - For the `Client Inventory`, we will store each `item ID` and each `quantity of item` as its own **index** in the Client memory record. The `dataSizes` table should be defined as:

    ```lua
    local dataSizes = {
        [1] = 4 -- Allocates 4 Byte of memory to the ID of 1 for SCORE. (Previous)
        [2] = 4 -- Allocates 4 Bytes of memory to the ID of 2 for LEVEL. (Previous)
        [3] = 4 -- Allocates 4 Bytes of memory to the ID of 3 for CHECKPOINT. (Previous)
    }

    for i = 4, 62, 2 do -- Allocating IDs 4 - 64 to the Inventory Slots
   		dataSizes[i] = 2; -- ID for the ITEM (MAX 65536 unique items)
   		dataSizes[i+1] = 1; -- ID for the QUANITITY (MAX 256 items)
   	end
    ```
  - In the `Server.lua` script, the constant `SLOT_OFFSET` is defined as followed:

    ```lua
     SLOT_OFFSET = 4 -- Offset in the dataSizes table (index of 4 to start the inventory so change if not offset by 4).
     ```
    The `SLOT_OFFSET` locates the beginning of the inventory in the database. In the `dataSizes` table we defined, we start at slot 4, so we set `SLOT_OFFSET` to 4.
    
  - In the `Server.lua` script, locate the `local playerJoins = function(player : Player)` and **uncomment** the following line:

     ```lua
     addToInventory(4, 23, 22, player) -- In Slot 4, add on 22x of the item with ID of 23 to the players database.
     ```
     
     This code will add `22x` quantity of an item with `serialised ID 23` to `slot 4` to the players Inventory.

  - In the `Server.lua` script, the function below allows for the `deletion` of **all items** in the inventory.

    ```lua
     clearInventory(player) -- Clears all of the data in the player inventory
     ```
    
