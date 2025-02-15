# Byte-based Buffer Storage System Module in Lua

This project showcases the effective manipulation of memory blocks to construct a Database system that can solve the problem of  [table](https://create.roblox.com/docs/reference/engine/libraries/table) memory overhead. Utilising [buffers](https://create.roblox.com/docs/reference/engine/libraries/buffer) for byte manipulation, we can significantly reduce the overhead in database systems commonly use in popular Roblox games.

### This Projects aimed to solve the following problems:

- Table overhead whilst stored in [**heap memory**.](https://create.roblox.com/docs/studio/optimization/memory-usage#luau-heap)
- Reduced database **memory usage** per record ensuring more records can be stored.
- Efficient ID **indirect addressing** and **block allocation** for fast record access.

## Project Details

A quick look into the Luau heap memory used in Roblox Studio reveals a larger overhead carried with using **Tables** in comparison to **Buffers**.

![image](https://github.com/user-attachments/assets/6d312755-3a44-453e-83a9-3e4500bfb64b)  
*Figure 1: Heap memory usage (in Bytes) from constructing a 25B Table with memory category "TABLE" and Buffer with memory category "BUFFER".*  

Therefore, storing large volumes of Player Data on the **Server** can become costly. To resolve this problem, I propose a solution which manages, stores and manipulates client data, whilst only utilising the Buffer type.

A more detailed approach can be found in the project youtube video:

[![A NEW way to SAVE PLAYER DATA In Roblox Studio](https://img.youtube.com/vi/ArnSFrDSJvE/hqdefault.jpg)](https://www.youtube.com/watch?v=ArnSFrDSJvE&t=0s)

**A NEW way to SAVE PLAYER DATA In Roblox Studio**

## Local Project Installation Guide

 - Download and open the `dataSystem.rbxl` file from this repository from your local computer. `ServerScriptService` will contain the code required to run the data module.
 - Copy the folder containing the package, and paste it into `ServerScriptService` of your Current Roblox Studio Environment.
