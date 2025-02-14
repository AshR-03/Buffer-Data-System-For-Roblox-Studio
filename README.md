# Byte-based Buffer Storage System Module in Lua

This project showcases the effective manipulation of memory blocks to construct a Database system that can solve the problem of table memory overhead. Utilising buffers for byte manipulation, we can significantly reduce the overhead in database systems commonly use in popular Roblox games.

## Project Details

A quick look into the Luau heap memory used in Roblox Studio reveals a larger overhead carried with using **Tables** in comparison to **Buffers**.

![image](https://github.com/user-attachments/assets/6d312755-3a44-453e-83a9-3e4500bfb64b)  
*Figure 1: Heap memory usage (in Bytes) from constructing a 25B Table labelled "TABLE" and Buffer labelled "BUFFER".*  

Therefore, storing large volumes of Player Data on the **Server** can become costly. To resolve this problem, I propose a solution which manages, stores and manipulates client data, whilst only utilising the Buffer type.

A more detailed approach can be found in the project youtube video:

[![A NEW way to SAVE PLAYER DATA In Roblox Studio](https://img.youtube.com/vi/ArnSFrDSJvE/hqdefault.jpg)](https://www.youtube.com/watch?v=ArnSFrDSJvE&t=0s)

**A NEW way to SAVE PLAYER DATA In Roblox Studio**
