--!native
-- SERVICES --

local PlayerService = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");


-- MODULES --

local PlayerData = require(script.Parent.Server.ServerStore);
local DataManager = require(script.Parent.Server.DataManager);

-- CONSTANTS -- 

local SETUP = ReplicatedStorage.Events.Leaderstats.Setup;

-- EVENTS --

SETUP.Event:Connect(function(player : Player)
	print("Setting up leaderstats");
	
	local leaderstatsFile = Instance.new("Folder");
	leaderstatsFile.Name = "leaderstats";
	leaderstatsFile.Parent = player;
	
	local playerBuffer = PlayerData[player.UserId];
	
	local score = Instance.new("NumberValue");
	score.Name = "Score";
	score.Value = DataManager.readData(playerBuffer, 1);
	score.Parent = leaderstatsFile;
	
	local level = Instance.new("NumberValue");
	level.Name = "Level";
	level.Value = DataManager.readData(playerBuffer, 2);
	level.Parent = leaderstatsFile;
	
	local checkpoint = Instance.new("NumberValue");
	checkpoint.Name = "CheckPoint";
	checkpoint.Value = DataManager.readData(playerBuffer, 3);
	checkpoint.Parent = leaderstatsFile;
end)