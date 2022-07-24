-- yes  i am gonna rewrite this, i am just rushing it all

local RunService = game:GetService("RunService")
local UILibrary = loadfile("UILibrary.lua")();
local VisualsLib = loadfile("Visuals.lua")();
local Visuals = VisualsLib.new();
local Services = setmetatable({}, {
    __index = function(self, serviceName)
        local good, service = pcall(game.GetService, game, serviceName);
        if (good) then
            self[serviceName] = service
            return service;
        end
    end
});

local Workspace = Services.Workspace
local currentCamera = Workspace.currentCamera
local worldtoscreen = currentCamera.WorldToScreenPoint
local viewportSize = currentCamera.ViewportSize
local ReplicatedStorage = Services.ReplicatedStorage
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse();
local mouseVector = Vector2.new(Mouse.X, Mouse.Y);
local inset = Services.GuiService:GetGuiInset();

local findFirstChild = game.FindFirstChild
local waitForChild = game.WaitForChild
local findPartOnRayWithIgnoreList = Workspace.FindPartOnRayWithIgnoreList
local GetPartsObscuringTarget = currentCamera.GetPartsObscuringTarget

local cframenew = CFrame.new
local cframe_angles = CFrame.Angles
local vector3new = Vector3.new
local vector2new = Vector2.new
local color3new = Color3.new
local fromRGB = Color3.fromRGB
local wait = task.wait
local split = string.split
local format = string.format
local floor = math.floor
local rad = math.rad
local random = math.random
local create = table.create
local tfind = table.find
local insert = table.insert
local IsA = game.IsA

local protectedInstances = {};
local keys = {};

local settings = {
    auto_farm = false,
    tween_speed = 1,
    fast_attack = false,
	target_only_attacking = true,
    offsets = {
        X = 3,
        Y = 10,
        Z = 0,
    },
    tool = "Fishman Karate",
	auto_third = false,
	auto_second = false,
	auto_training = {
		buso = false,
		observation = false
	},
	auto_skill_wep = nil,
	auto_skills = {},
	auto_skill = false,
	auto_skill_percentage = 13,
	auto_skill_hold = 0,
	auto_snipe_fruits = false,

	character = {},
	cooldowns = {}
};

local trampoline_call = function(func, ...)
    local funcinfo = debug.getinfo(func);
    local funcenv = getfenv(func);
    local result = {syn.trampoline_call(func, {
        env = funcenv,
        source = funcinfo.source,
        name = funcinfo.name,
        currentline = funcinfo.currentline,
        numparams = funcinfo.numparams,
        is_varag = funcinfo.is_vararg
    }, {
        identity = 2,
        script = script,
        env = funcenv
    }, ...)}
    if (result[1]) then
        return unpack(result, 2);
    end
    error("trampoline call error:\n" .. debug.traceback());
end

local __namecall;
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if (not checkcaller() and getnamecallmethod() == "GetDescendants") then
        local descendants = __namecall(self, ...);
        local filteredDescendants = {};
        for index, descendant in pairs(descendants) do
            if (not table.find(protectedInstances, descendant)) then
                filteredDescendants[#filteredDescendants + 1] = descendant
            end
        end
        return filteredDescendants;
    end
    return __namecall(self, ...);
end);

local __newindex;
__newindex = hookmetamethod(game, "__newindex", function(self, prop, val)
    if (not checkcaller() and self.ClassName == "Humanoid") then
		if (prop == "WalkSpeed") then
			if (settings.character.jumping) then
				__newindex(self, "JumpPower", settings.character.jumppower);
			end
			if (settings.character.speeding) then
				return __newindex(self, prop, settings.character.walkspeed);
			end
		end
    end
    return __newindex(self, prop, val);
end);

local __index, energyValue;
__index = hookmetamethod(game, "__index", function(self, prop)
	if (not checkcaller() and self == energyValue and prop == "Value") then
		return __index(self, "MaxValue");
	end
	return __index(self, prop);
end);

local protectInstance = function(instance)
    protectedInstances[#protectedInstances + 1] = instance
end

local tweento = function(pos, noyield)
    local char = LocalPlayer.Character
    if (char) then
        local root = char.HumanoidRootPart
        local distance = (root.Position - pos.Position).Magnitude
        local tweenInfo = TweenInfo.new(distance / 250 * settings.tween_speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        local tween = TweenService:Create(root, tweenInfo, { CFrame = pos });
        tween:Play();
        if (not noyield) then
            tween.Completed:Wait();
        end
        return true;
    end
    return false
end

local serverhop = function(order)
    local Servers = {};
    local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100", game.PlaceId, order);
    local starting = tick();
    local Server;
    repeat
        local good, result = pcall(function()
            return game:HttpGet(url);
        end);
        if (not good) then
            wait(2);
            continue;
        end
        local decoded = Services.HttpService:JSONDecode(result);
        if (#decoded.data ~= 0) then
            Servers = decoded.data
            for i, v in pairs(Servers) do
                if (v.maxPlayers and v.playing and v.maxPlayers > v.playing) then
                    Server = v
                    break;
                end
            end
            if (Server) then
                break;
            end
        end
        url = format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100&cursor=%s", game.PlaceId, order, decoded.nextPageCursor);
    until tick() - starting >= 600;
    if (not Server or #Servers == 0) then
        return "no servers found";
    end

    local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport
    if (queue_on_teleport) then
        queue_on_teleport("print('scripthere')");
    end;

    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id);    
end

local flyChar = function(camera, root, speed)
    local bodyGyro = Instance.new("BodyGyro");
    local bodyVelocity = Instance.new("BodyVelocity");

    protectInstance(bodyGyro);
    protectInstance(bodyVelocity);
    bodyGyro.Parent = root
    bodyVelocity.Parent = root
    bodyGyro.P = 9e9
    bodyGyro.MaxTorque = Vector3.one * 9e9
    bodyGyro.CFrame = root.CFrame
    bodyVelocity.MaxForce = Vector3.one * 9e9
    bodyVelocity.Velocity = Vector3.zero

    local veczero = Vector3.zero

    local WASD = { W = 0, A = 0, S = 0, D = 0 };
    camera = camera or currentCamera
    speed = math.clamp(speed or 3, 1, 7);
    task.spawn(function()
        settings.character.flying = true
        while (settings.character.flying) do
            WASD.W = keys.W and speed or 0
            WASD.A = keys.A and -speed or 0
            WASD.S = keys.S and -speed or 0
            WASD.D = keys.D and speed or 0
            if ((WASD.W + WASD.S) ~= 0 or (WASD.A + WASD.D) ~= 0) then
                bodyVelocity.Velocity = ((camera.CoordinateFrame.lookVector * (WASD.W + WASD.S)) + ((camera.CoordinateFrame * CFrame.new(WASD.A + WASD.D, (WASD.W + WASD.S) * 0.2, 0).Position) - camera.CoordinateFrame.Position)) * 50
            else
                bodyVelocity.Velocity = veczero
            end
            bodyGyro.CFrame = camera.CoordinateFrame
            wait();
        end
        bodyVelocity:Destroy();
        bodyGyro:Destroy();
    end);
end

local questOrder = {
	{
		levels = { 1, 10 },
		NPCName = "Bandit",
		questNumber = 1,
		questPosition = { 1060, 16, 1547 },
		questName = "BanditQuest1"
	},
	{
		levels = { 11, 15 },
		NPCName = "Monkey",
		questNumber = 1,
		questPosition = { -1604, 36, 154 },
		questName = "JungleQuest"
	},
	{
		levels = { 16, 30 },
		NPCName = "Gorilla",
		questNumber = 2,
		questPosition = { -1601, 36, 153 },
		questName = "JungleQuest"
	},
	{
		levels = { 31, 40 },
		NPCName = "Pirate",
		questNumber = 1,
		questPosition = { -1140, 4, 3827 },
		questName = "BuggyQuest1"
	},
	{
		levels = { 41, 60 },
		NPCName = "Brute",
		questNumber = 2,
		questPosition = { -1140, 4, 3827 },
		questName = "BuggyQuest1"
	},
	{
		levels = { 61, 75 },
		NPCName = "Desert Bandit",
		questNumber = 1,
		questPosition = { 896, 6, 4390 },
		questName = "DesertQuest"
	},
	{
		levels = { 76, 90 },
		NPCName = "Desert Officer",
		questNumber = 2,
		questPosition = { 896, 6, 4390 },
		questName = "DesertQuest"
	},
	{
		levels = { 91, 100 },
		NPCName = "Snow Bandit",
		questNumber = 1,
		questPosition = { 1386, 87, -1298 },
		questName = "SnowQuest"
	},
	{
		levels = { 101, 120 },
		NPCName = "Snowman",
		questNumber = 2,
		questPosition = { 1386, 87, -1298 },
		questName = "SnowQuest"
	},
	{
		levels = { 121, 150 },
		NPCName = "Chief Petty Officer",
		questNumber = 1,
		questPosition = { -5035, 28, 4324 },
		questName = "MarineQuest2"
	},
	{
		levels = { 151, 175 },
		NPCName = "Sky Bandit",
		questNumber = 1,
		questPosition = { -4841, 717, -2623 },
		questName = "SkyQuest"
	},
	{
		levels = { 176, 250 },
		NPCName = "Dark Master",
		questNumber = 2,
		questPosition = { -4841, 717, -2623 },
		questName = "SkyQuest"
	},
	{
		levels = { 251, 275 },
		NPCName = "Toga Warrior",
		questNumber = 1,
		questPosition = { -1576, 7, -2983 },
		questName = "ColosseumQuest"
	},
	{
		levels = { 276, 300 },
		NPCName = "Gladiator",
		questNumber = 2,
		questPosition = { -1576, 7, -2983 },
		questName = "ColosseumQuest"
	},
	{
		levels = { 301, 330 },
		NPCName = "Military Soldier",
		questNumber = 1,
		questPosition = { -5316, 12, 8517 },
		questName = "MagmaQuest"
	},
	{
		levels = { 301, 375 },
		NPCName = "Military Spy",
		questNumber = 2,
		questPosition = { -5316, 12, 8517 },
		questName = "MagmaQuest"
	},
	{
		levels = { 376, 400 },
		NPCName = "Fishman Warrior",
		questNumber = 1,
		questPosition = { 61122, 18, 1568 },
		questName = "FishmanQuest"
	},
	{
		levels = { 401, 450 },
		NPCName = "Fishman Commando",
		questNumber = 2,
		questPosition = { 61122, 18, 1568 },
		questName = "FishmanQuest"
	},
	{
		levels = { 451, 475 },
		NPCName = "God's Guard",
		questNumber = 1,
		questPosition = { -4721, 845, -1954 },
		questName = "SkyExp1Quest"
	},
	{
		levels = { 476, 525 },
		NPCName = "Shanda",
		questNumber = 2,
		questPosition = { -7863, 5545, -379 },
		questName = "SkyExp1Quest"
	},
	{
		levels = { 526, 550 },
		NPCName = "Royal Squad",
		questNumber = 1,
		questPosition = { -7902, 5635, -1411 },
		questName = "SkyExp2Quest"
	},
	{
		levels = { 551, 625 },
		NPCName = "Royal Soldier",
		questNumber = 2,
		questPosition = { -7902, 5635, -1411 },
		questName = "SkyExp2Quest"
	},
	{
		levels = { 626, 700 },
		NPCName = "Galley Pirate",
		questNumber = 1,
		questPosition = { 5254, 38, 4049 },
		questName = "FountainQuest"
	},
	{
		levels = { 701, 725 },
		NPCName = "Raider",
		questNumber = 1,
		questPosition = { -424, 73, 1836 },
		questName = "Area1Quest"
	},
	{
		levels = { 726, 775 },
		NPCName = "Mercenary",
		questNumber = 2,
		questPosition = { -424, 73, 1836 },
		questName = "Area1Quest"
	},
	{
		levels = { 776, 875 },
		NPCName = "Swan Pirate",
		questNumber = 1,
		questPosition = { 632, 73, 918 },
		questName = "Area2Quest"
	},
	{
		levels = { 876, 900 },
		NPCName = "Marine Lieutenant",
		questNumber = 1,
		questPosition = { -2442, 73, -3219 },
		questName = "MarineQuest3"
	},
	{
		levels = { 901, 950 },
		NPCName = "Marine Captain",
		questNumber = 2,
		questPosition = { -2442, 73, -3219 },
		questName = "MarineQuest3"
	},
	{
		levels = { 951, 975 },
		NPCName = "Zombie",
		questNumber = 1,
		questPosition = { -5492, 48, -793 },
		questName = "ZombieQuest"
	},
	{
		levels = { 976, 1000 },
		NPCName = "Vampire",
		questNumber = 2,
		questPosition = { -5492, 48, -793 },
		questName = "ZombieQuest"
	},
	{
		levels = { 1001, 1050 },
		NPCName = "Snow Trooper",
		questNumber = 1,
		questPosition = { 604, 401, -5371 },
		questName = "SnowMountainQuest"
	},
	{
		levels = { 1051, 1100 },
		NPCName = "Winter Warrior",
		questNumber = 2,
		questPosition = { 604, 401, -5371 },
		questName = "SnowMountainQuest"
	},
	{
		levels = { 1101, 1125 },
		NPCName = "Lab Subordinate",
		questNumber = 1,
		questPosition = { -6060, 15, -4904 },
		questName = "IceSideQuest"
	},
	{
		levels = { 1126, 1175 },
		NPCName = "Horned Warrior",
		questNumber = 2,
		questPosition = { -6060, 15, -4904 },
		questName = "IceSideQuest"
	},
	{
		levels = { 1176, 1200 },
		NPCName = "Magma Ninja",
		questNumber = 1,
		questPosition = { -5431, 15, -5296 },
		questName = "FireSideQuest"
	},
	{
		levels = { 1201, 1350 },
		NPCName = "Lava Pirate",
		questNumber = 2,
		questPosition = { -5431, 15, -5296 },
		questName = "FireSideQuest"
	},
	{
		levels = { 1351, 1375 },
		NPCName = "Arctic Warrior",
		questNumber = 1,
		questPosition = { 5669, 28, -6482 },
		questName = "FrostQuest"
	},
	{
		levels = { 1376, 1425 },
		NPCName = "Snow Lurker",
		questNumber = 2,
		questPosition = { 5669, 28, -6482 },
		questName = "FrostQuest"
	},
	{
		levels = { 1426, 1450 },
		NPCName = "Sea Soldier",
		questNumber = 1,
		questPosition = { -3052, 236, -10148 },
		questName = "ForgottenQuest"
	},
	{
		levels = { 1451, 1500 },
		NPCName = "Water Fighter",
		questNumber = 2,
		questPosition = { -3052, 236, -10148 },
		questName = "ForgottenQuest"
	},
	{
		levels = { 1501, 1525 },
		NPCName = "Pirate Millionaire",
		questNumber = 1,
		questPosition = { -290, 42, 5581 },
		questName = "PiratePortQuest"
	},
	{
		levels = { 1526, 1575 },
		NPCName = "Pistol Billionaire",
		questNumber = 2,
		questPosition = { -290, 42, 5581 },
		questName = "PiratePortQuest"
	},
	{
		levels = { 1576, 1600 },
		NPCName = "Dragon Crew Warrior",
		questNumber = 1,
		questPosition = { 5832, 51, -1101 },
		questName = "AmazonQuest"
	},
	{
		levels = { 1601, 1625 },
		NPCName = "Dragon Crew Archer",
		questNumber = 2,
		questPosition = { 5832, 51, -1101 },
		questName = "AmazonQuest"
	},
	{
		levels = { 1626, 1650 },
		NPCName = "Female Islander",
		questNumber = 1,
		questPosition = { 5448, 601, 751 },
		questName = "AmazonQuest2"
	},
	{
		levels = { 1651, 1700 },
		NPCName = "Giant Islander",
		questNumber = 2,
		questPosition = { 5448, 601, 751 },
		questName = "AmazonQuest2"
	},
	{
		levels = { 1701, 1725 },
		NPCName = "Marine Commodore",
		questNumber = 1,
		questPosition = { 2180, 27, -6741 },
		questName = "MarineTreeIsland"
	},
	{
		levels = { 1726, 1775 },
		NPCName = "Marine Rear Admiral",
		questNumber = 2,
		questPosition = { 2180, 27, -6741 },
		questName = "MarineTreeIsland"
	},
	{
		levels = { 1776, 1800 },
		NPCName = "Fishman Raider",
		questNumber = 1,
		questPosition = { -10581, 330, -8761 },
		questName = "DeepForestIsland3"
	},
	{
		levels = { 1801, 1825 },
		NPCName = "Fishman Captain",
		questNumber = 2,
		questPosition = { -10581, 330, -8761 },
		questName = "DeepForestIsland3"
	},
	{
		levels = { 1826, 1850 },
		NPCName = "Forest Pirate",
		questNumber = 1,
		questPosition = { -13234, 331, -7625 },
		questName = "DeepForestIsland"
	},
	{
		levels = { 1851, 1900 },
		NPCName = "Mythological Pirate",
		questNumber = 2,
		questPosition = { -13234, 331, -7625 },
		questName = "DeepForestIsland"
	},
	{
		levels = { 1901, 1925 },
		NPCName = "Jungle Pirate",
		questNumber = 1,
		questPosition = { -12680, 389, -9902 },
		questName = "DeepForestIsland2"
	},
	{
		levels = { 1926, 1975 },
		NPCName = "Musketeer Pirate",
		questNumber = 2,
		questPosition = { -12680, 389, -9902 },
		questName = "DeepForestIsland2"
	},
	{
		levels = { 1976, 2000 },
		NPCName = "Reborn Skeleton",
		questNumber = 1,
		questPosition = { -9480, 142, 5566 },
		questName = "HauntedQuest1"
	},
	{
		levels = { 2001, 2025 },
		NPCName = "Living Zombie",
		questNumber = 2,
		questPosition = { -9480, 142, 5566 },
		questName = "HauntedQuest1"
	},
	{
		levels = { 2026, 2050 },
		NPCName = "Demonic Soul",
		questNumber = 1,
		questPosition = { -9516, 178, 6078 },
		questName = "HauntedQuest2"
	},
	{
		levels = { 2051, 2075 },
		NPCName = "Posessed Mummy",
		questNumber = 2,
		questPosition = { -9516, 178, 6078 },
		questName = "HauntedQuest2"
	},
	{
		levels = { 2076, 2100 },
		NPCName = "Peanut Scout",
		questNumber = 1,
		questPosition = { -2104, 38, -10194 },
		questName = "NutsIslandQuest"
	},
	{
		levels = { 2101, 2125 },
		NPCName = "Peanut President",
		questNumber = 2,
		questPosition = { -2104, 38, -10194 },
		questName = "NutsIslandQuest"
	},
	{
		levels = { 2126, 2150 },
		NPCName = "Ice Cream Chef",
		questNumber = 1,
		questPosition = { -820, 65, -10966 },
		questName = "IceCreamIslandQuest"
	},
	{
		levels = { 2151, 2300 },
		NPCName = "Ice Cream Commander",
		questNumber = 2,
		questPosition = { -820, 65, -10966 },
		questName = "IceCreamIslandQuest"
	},
};

local HasTag = function(tagName)
	local char = LocalPlayer.Character
	if (not char) then return false; end
	return Services.CollectionService:HasTag(char, tagName);
end

local keyPress = function(key) -- need to change soon
	Services.VirtualInputManager:SendKeyEvent(true, key, false, nil);
end

local keyRelease = function(key)
	Services.VirtualInputManager:SendKeyEvent(false, key, false, nil);
end

local CombatFrameworkOld = require(LocalPlayer.PlayerScripts.CombatFramework);
local CombatFramework = debug.getupvalue(CombatFrameworkOld, 2);
local CameraShaker = require(ReplicatedStorage.Util.CameraShaker);
CameraShaker:Stop();

local equipT = function(char, tName)
	local toolEquipped = char:FindFirstChildOfClass("Tool");
	if (toolEquipped and toolEquipped.Name ~= tName) then
		toolEquipped.Parent = LocalPlayer.Backpack
	end
	if (not toolEquipped or toolEquipped.Name ~= tName) then
		local tool = findFirstChild(LocalPlayer.Backpack, tName) or findFirstChild(char, tName);
		if (tool) then
			tool.Parent = char;
		end
		return tool;
	end
end

local attack = function()
	if (not settings.tool) then
		return;
	end
    local char = LocalPlayer.Character
    if (char) then
        equipT(char, settings.tool);
        local connections = getconnections(Mouse.Button1Down);
        if (connections[1] and connections[1].Function) then
            connections[1].Function();
        end
    end

    return char;
end

RunService.RenderStepped:Connect(function()
	local activeController = CombatFramework.activeController

	local char = LocalPlayer.Character

	if (not char or not activeController) then return; end
	if (settings.auto_farm) then
		activeController.hitboxMagnitude = 55
	end

	if (settings.fast_attack) then
		if findFirstChild(char, "Black Leg") then
			activeController.timeToNextAttack = 3
		elseif findFirstChild(char, "Electro") then
			activeController.timeToNextAttack = 2
		else
			activeController.timeToNextAttack = 0
		end

		activeController.attacking = false
		activeController.increment = 3
		activeController.blocking = false
		activeController.timeToNextBlock = 0
		char.Humanoid.Sit = false
	end
end);

local fastattack = function()
	local char = LocalPlayer.Character
	if (not char) then return; end
    attack();

    local stun = findFirstChild(char, "Stun");
    if (stun) then
        stun.Value = 0
    end
end

local skillAttack = function(npcHum, d)
	if (not settings.auto_skill_wep) then
		return;
	end
	local char = LocalPlayer.Character
	local toolEquipped = equipT(char, settings.auto_skill_wep);

	local npc = npcHum.Parent
	npcHum:GetPropertyChangedSignal("Health"):Connect(function()
		local npcHealth = npcHum.Health
		local npcMaxHealth = npcHum.MaxHealth
		if (((npcHealth / npcMaxHealth) * 100) >= settings.auto_skill_percentage) then
			table.remove(d, table.find(d, npc));
		end
	end);

	wait(1);
	repeat
		for skill, enabled in pairs(settings.auto_skills) do
			if (not toolEquipped) then
				toolEquipped = equipT(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait(), settings.auto_skill_wep);
			end
			if (not toolEquipped) then
				table.remove(d, table.find(d, npc));
				break;
			end

			local attr = skill .. toolEquipped.ToolTip .. "CooldownClient"
			local cooldownClient = char:GetAttribute(attr);
			repeat
				cooldownClient = char:GetAttribute(attr);
				wait(.1);
			until not cooldownClient;

			equipT(char, settings.auto_skill_wep);

			if (not cooldownClient and enabled) then
				keyPress(skill);
				wait(settings.auto_skill_hold);
				keyRelease(skill);
			end
		end
	until npcHum.Health == 0 or npcHum.Parent == nil or not table.find(d, npc);

	table.remove(d, table.find(d, npc));
end

local enemies = Workspace:FindFirstChild("Enemies");

local getNPCsFromName = function(find)
    local char = LocalPlayer.Character
    if (not char) then return; end
    local localRoot = findFirstChild(char, "HumanoidRootPart");
    local localPos = localRoot.Position

    local enemiesChildren = enemies:GetChildren();
    local found = {};
    for i = 1, #enemiesChildren do
        local enemy = enemiesChildren[i]
        if (string.find(enemy.Name, find) or enemy.Name == find) then
            local root = findFirstChild(enemy, "HumanoidRootPart");
            if (root and not root.Anchored) then
                found[#found + 1] = {enemy, (localPos - root.Position).Magnitude};
            end
        end
    end

    repeat
        local swapped = false
        for i = 2, #found do
            if (found[i - 1][2] > found[i][2]) then
                found[i], found[i - 1] = found[i - 1], found[i]
                swapped = true
            end
        end
    until swapped == false;

    for i = 1, #found do
        found[i] = found[i][1]
    end

    return found;
end

local getClosestNPC = function(list)
    local char = LocalPlayer.Character
    local pos = nil
    if (char) then
        local root = char.HumanoidRootPart
        local dist, npc = math.huge, nil;
        local enemiesChildren = enemies:GetChildren();
        local n = list and #list or #enemiesChildren
        for i = 1, n do
            local enemy = (list or enemiesChildren)[i]
            local enemyRoot = findFirstChild(enemy, "HumanoidRootPart");
            local enemyHumanoid = findFirstChild(enemy, "Humanoid");
            local mag = enemyRoot and (root.Position - enemyRoot.Position).Magnitude or false
            if (not enemyRoot.Anchored and enemyRoot and dist > mag and enemyHumanoid and enemyHumanoid.Health ~= 0) then
                pos = enemyRoot.CFrame
                dist = mag
                npc = enemy
            end
        end
        return npc, pos;
    end
end

local one = cframenew(1, 1, 1);
local bring = function(npc, offset)
    sethiddenproperty(LocalPlayer, "SimulationRadius", 2000);
    wait();

    local char = LocalPlayer.Character
    local localRoot = findFirstChild(char, "HumanoidRootPart");
    local root = findFirstChild(npc, "HumanoidRootPart");

    if (localRoot and root and isnetworkowner(root)) then
        root.CFrame = localRoot.CFrame * (offset or one);
    end
end

local forcelvl = nil
local getLevel = function()
	return forcelvl or LocalPlayer.Data.Level.Value + 1
end

local getQuestInfo = function()
    local level = getLevel();

    for i, questInfo in pairs(questOrder) do
        local NPClevels = questInfo.levels
        if (level >= NPClevels[1] and level <= NPClevels[2]) then
            return questInfo;
        end
    end
end

local remotes = ReplicatedStorage:FindFirstChild("Remotes");
local commF = remotes.CommF_
local commE = remotes.CommE

local startQuest = function()
    local questInfo = getQuestInfo();
    local questPosition = cframenew(unpack(questInfo.questPosition));
    local char = LocalPlayer.Character
    local root = findFirstChild(char, "HumanoidRootPart");
    local oldPos = root.CFrame
    local distance = (root.Position - questPosition.Position).Magnitude
	local spawnSet = false
	local lvl = getLevel();
	if (376 <= lvl and 450 >= lvl) then
		print("true in bounds");
		local portal = Workspace._WorldOrigin.PlayerSpawns.Pirates.Fishman:GetBoundingBox();
		local portalDist = (oldPos.Position - portal.Position).Magnitude
		local exitPortal = workspace.Map.TeleportSpawn.Exit.CFrame
		local exitPortalDist = (oldPos.Position - exitPortal.Position).Magnitude
		if ((portalDist >= 3000 or portalDist <= 500) and (oldPos.Position - questPosition.Position).Magnitude >= 1000) then
			print("tping to portal fishman");
			tweento(portal);
			for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
			spawnSet = true
			wait(3);
		end
	elseif (lvl == 450) then
		LocalPlayer.Character:BreakJoints();
		LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart");
	end
    tweento(questPosition);
    if (distance > 1000) then
        wait();
        if (not spawnSet) then
			print("setting dumb spawn");
			for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
		end
    end
    commF:InvokeServer("StartQuest", questInfo.questName, questInfo.questNumber);
end

local questActive = function()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
    local MainUI = PlayerGui:FindFirstChild("Main");
    local Quest = MainUI:FindFirstChild("Quest");
    return Quest.Visible, Quest;
end

local activeQuestData = function()
    local active, questUI = questActive();
    if (not active) then commF:InvokeServer("AbandonQuest"); wait(); startQuest(); wait(.1); active, questUI = questActive(); end
    local questTitle = questUI:FindFirstChild("QuestTitle", true);
    if (questTitle) then
        local title = questTitle:FindFirstChild("Title");
        local progress = string.match(title.Text, ".*(%d/%d)");
        local killData = string.split(progress, "/");
        return {
            killed = tonumber(killData[1]),
            amountToKill = tonumber(killData[2])
        };
    end
    return {
        killed = 0,
        amountToKill = 0
    };
end

local characterPos = vector3new();
local attackingNPCs = {};
local sKillingNPCs = {};
local offsets = settings.offsets;

local old;
old = hookmetamethod(game, "__index", function(self, prop)
	if (self == Mouse and prop == "Hit") then
		local npc = sKillingNPCs[#sKillingNPCs]
		if (npc and settings.auto_farm and settings.auto_skill) then
			local root = findFirstChild(npc, "HumanoidRootPart");
			if (root) then
				return root.CFrame;
			end
		end
	end
	return old(self, prop);
end)

local attackNPCs = function(thread, NPCName, fakeQuest)
	local threadResumed = false
    local questConnections = {};

    local active = questActive();
    if (not active and not fakeQuest) then
        startQuest();
        wait(.5);
    end

    local currentQuestData = fakeQuest and {
		killed = 0,
        amountToKill = 2
    } or activeQuestData();

    local char = LocalPlayer.Character
    local attackingPosition = CFrame.new(settings.offsets.X, settings.offsets.Y, settings.offsets.Z);
    local offset = CFrame.new(-3, -(settings.offsets.Y - 5), 0);
	local tweening = false

    local function wakeNPC(npc, first)
        local npcHumanoid = npc:WaitForChild("Humanoid");
        if (npcHumanoid.Health == 0 or table.find(attackingNPCs, npc)) then return; end
		print("waking npc");
		npcHumanoid.Died:Connect(function()
            table.remove(attackingNPCs, table.find(attackingNPCs, npc));
            wait(.1);
			print("killed");
            if (fakeQuest or (not threadResumed and not questActive())) then
				print("resumed!!");
                coroutine.resume(thread);
                threadResumed = true
                for i, connection in pairs(questConnections) do
                    connection:Disconnect();
                end
            end
        end);
        attackingNPCs[#attackingNPCs + 1] = npc

        local localRoot = char:FindFirstChild("HumanoidRootPart");
        local npcRoot = npc:FindFirstChild("HumanoidRootPart");
        local oldPosition = localRoot.CFrame
        if (first) then
            tweento(npcRoot.CFrame);
            wait();
        end
        local con;
        con = RunService.Heartbeat:Connect(function()
            if (localRoot and npcRoot) then
                localRoot.CFrame = npcRoot.CFrame * attackingPosition
                attack();
            end
        end);
        wait(.1);
        con:Disconnect();

		localRoot.CFrame = oldPosition
        task.spawn(function()
            for i = 1, 3 do
                bring(npc, offset);
                wait(.1);
            end
        end);
    end

    local aliveNPCs = getNPCsFromName(NPCName);
    for i = 1, currentQuestData.amountToKill - currentQuestData.killed do
        local npc = aliveNPCs[i]
        if (npc) then
            wakeNPC(npc, i == 1);
        end
    end

	local qInfo = getQuestInfo();
	local qPosition = vector3new(unpack(qInfo.questPosition));
    questConnections[#questConnections + 1] = RunService.Heartbeat:Connect(function()
		if (not settings.auto_farm and not fakeQuest or force) then
            coroutine.resume(thread);
            threadResumed = true
            for i, connection in pairs(questConnections) do
                connection:Disconnect();
            end
            return;
        end

        char = LocalPlayer.Character
        if (not char) then return; end
        local localRoot = char:FindFirstChild("HumanoidRootPart");
        if (localRoot) then
            local npc, pos = getClosestNPC(#sKillingNPCs == 0 and attackingNPCs or sKillingNPCs);
            if (pos and not tweening) then
                local newpos = cframenew(pos.Position) * attackingPosition
				localRoot.CFrame = newpos
				characterPos = localRoot.Position
				local npcHum = findFirstChild(npc, "Humanoid");
				local npcHealth = npcHum.Health
				local npcMaxHealth = npcHum.MaxHealth
				if (settings.auto_skill and ((npcHealth / npcMaxHealth) * 100) <= settings.auto_skill_percentage and not table.find(sKillingNPCs, npc)) then
					sKillingNPCs[#sKillingNPCs + 1] = npc
					skillAttack(npcHum, sKillingNPCs);
				elseif (not table.find(sKillingNPCs, npc)) then
					if (settings.fast_attack or fakeQuest) then
						fastattack();
					else
						attack();
					end
				end
            end
            for i = 1, #attackingNPCs do
                local npc = attackingNPCs[i]
                if (npc) then
                    local root = findFirstChild(npc, "HumanoidRootPart");
                    if (root and (characterPos - root.Position).Magnitude > 30) then
                        bring(npc, offset);
                    end
                end
            end
        end
		local activeController = CombatFramework.activeController
		if (activeController) then
			activeController.hitboxMagnitude = 55
		end

		if (#attackingNPCs == 0 and not tweening) then
			local aliveNPCs = getNPCsFromName(NPCName);
			for i = 1, currentQuestData.amountToKill - currentQuestData.killed do
				local npc = aliveNPCs[i]
				if (npc) then
					wakeNPC(npc, i == 1);
				end
			end
		end

		if (not fakeQuest and #getNPCsFromName(NPCName) == 0 and (localRoot.Position - qPosition).Magnitude > 100 and not tweening) then
			tweening = true
			tweento(CFrame.new(qPosition));
			tweening = false
		end

        attackingPosition = CFrame.new(settings.offsets.X, settings.offsets.Y, settings.offsets.Z);
    end);

    questConnections[#questConnections + 1] = enemies.ChildAdded:Connect(function(npc)
        local npcName = npc.Name
        if (string.find(npcName, NPCName) or npcName == NPCName) then
			repeat wait(); until not tweening
            wakeNPC(npc);
        end
    end);
end

local function startZou()
	tweento(CFrame.new(-342, 331, 642));
	local allFruits = commF:InvokeServer("GetFruits");
	local money = LocalPlayer.Data.Beli.Value
	local Backpack = LocalPlayer.Backpack
	local fruitfound = false
	local checkFruit = function()
		for i, fruit in pairs(Backpack:GetChildren()) do
			if (fruit.ToolTip == "") then
				for i, fruitData in pairs(allFruits) do
					if (fruit.Name == fruitData.Name) then
						if (fruitData.Price >= 1000000) then
							fruitfound = fruit
							break;
						end
					end
				end
				if (fruitfound) then
					break;
				end
			end
		end
	end
	checkFruit();
end

local doQuest = function()
    table.clear(attackingNPCs);

    local thread = coroutine.running();

	local questInfo = getQuestInfo();
	attackNPCs(thread, questInfo.NPCName, false);

    coroutine.yield();
	if (settings.auto_third or settings.auto_second) then
		local level = getLevel();
		if (level >= 700) then
			startDressrosa();
			coroutine.yield();
		end
	end
end

local doBoss = function()
	local bossName = settings.boss_name

	local thread = coroutine.running();
	local found = false
	for i, enemy in pairs(enemies:GetChildren()) do
		local hum = enemy:FindFirstChild("Humanoid");
		if (enemy.Name == bossName and hum and hum.Health ~= 0) then
			found = true
		end
	end


	if (found) then
		print("attacking ".. bossName);
		attackNPCs(thread, bossName, true);
		coroutine.yield();
	end
end


local function startSaberQuest()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	local root = char:WaitForChild("HumanoidRootPart");
	local locations = Workspace._WorldOrigin.Locations
	local map = workspace.Map
	local desert = locations.Desert
	local desertIsland = map.Desert
	local jungle = locations.Jungle
	local jungleIsland = map.Jungle

	local progress = commF:InvokeServer("ProQuestProgress");
	local platesDone = true
	for i, plateDone in pairs(progress.Plates) do
		if (not plateDone) then
			platesDone = false
		end
	end

	local questPlates = Workspace.Map.Jungle:WaitForChild("QuestPlates");
	if (not platesDone) then
		tweento(jungle.CFrame * CFrame.new(0, 150, 0));
		for i, plate in pairs(questPlates:GetChildren()) do
			local plateButton = plate:FindFirstChild("Button");
			if (plateButton) then
				tweento(plateButton.CFrame);
				firetouchinterest(plateButton, root, 0);
				wait();
				firetouchinterest(plateButton, root, 1);
			end
		end
		wait();
		return startSaberQuest();
	end

	if (not progress.UsedTorch) then
		local door = questPlates.Door
		tweento(door.CFrame);

		local torch = jungleIsland.Torch
		repeat
			firetouchinterest(torch, root, 0);
			wait();
			firetouchinterest(torch, root, 1);
			wait(.1);
		until LocalPlayer.Backpack:FindFirstChild("Torch") or char:FindFirstChild("Torch");
		tweento(desert.CFrame * CFrame.new(0, 150, 0));
		tweento(CFrame.new(1115, 4, 4349));

		torch = LocalPlayer.Backpack:FindFirstChild("Torch") or char:FindFirstChild("Torch");
		torch.Parent = char
		local burn = desertIsland:FindFirstChild("Burn");
		local fire = burn:FindFirstChild("Fire");
		firetouchinterest(torch.Handle, fire, 0);
		wait();
		firetouchinterest(torch.Handle, fire, 1);

		fire:GetPropertyChangedSignal("CanCollide"):Wait();
		return startSaberQuest();
	end

	if (not progress.UsedCup) then
		if (not LocalPlayer.Backpack:FindFirstChild("Cup") and not char:FindFirstChild("Cup")) then
			tweento(CFrame.new(1110, 4, 4362));
			local cup = desertIsland:FindFirstChild("Cup")
			repeat
				firetouchinterest(cup, root, 0);
				wait();
				firetouchinterest(cup, root, 1);
				wait(.1);
			until LocalPlayer.Backpack:FindFirstChild("Cup") or char:FindFirstChild("Cup");
		end
		tweento(CFrame.new(1395, 37, -1321));
		local cup = LocalPlayer.Backpack:FindFirstChild("Cup") or char:FindFirstChild("Cup");
		cup.Parent = char
		wait(1);
		commF:InvokeServer("ProQuestProgress", "FillCup", cup);
		wait(1);
		tweento(CFrame.new(1455, 88, -1388));
		commF:InvokeServer("ProQuestProgress", "SickMan");
		return startSaberQuest();
	end

	if (not progress.TalkedSon) then
		tweento(CFrame.new(-912, 13, 4077));
		wait(1);
		commF:InvokeServer("ProQuestProgress", "RichSon");

		return startSaberQuest();
	end

	if (not progress.KilledMob) then
		tweento(CFrame.new(-2844, 7, 5324));
		local thread = coroutine.running();
		local oldT = settings.auto_training.buso
		local old = settings.fast_attack
		settings.auto_training.buso = true
		settings.fast_attack = true
		attackNPCs(thread, "Mob Leader", true);
		coroutine.yield();
		settings.fast_attack = old
		settings.auto_training.buso = oldT
		return startSaberQuest();
	end

	if (not progress.UsedRelic) then
		tweento(CFrame.new(-912, 13, 4077));
		wait(1);
		commF:InvokeServer("ProQuestProgress", "RichSon");
		tweento(CFrame.new(-1405, 29, 4));
		local relic = LocalPlayer.Backpack:FindFirstChild("Relic") or char:FindFirstChild("Relic");
		relic.Parent = char
		local final = jungleIsland.Final
		firetouchinterest(relic.Handle, final.Invis, 0);
		wait();
		firetouchinterest(relic.Handle, final.Invis, 1);
		wait(2);
		return startSaberQuest();
	end

	if (not progress.KilledShanks) then
		tweento(CFrame.new(-1404, 29, 4));
		local thread = coroutine.running();
		local oldT = settings.auto_training.buso
		local old = settings.fast_attack
		settings.auto_training.buso = true
		settings.fast_attack = true
		attackNPCs(thread, "Saber Expert", true);
		coroutine.yield();
		settings.fast_attack = old
		settings.auto_training.buso = oldT
	end
	return true
end

local function startDressrosa()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	local root = char:WaitForChild("HumanoidRootPart");

	local locations = Workspace._WorldOrigin.Locations
	local map = workspace.Map
	local ice = locations["Frozen Village"]
	local iceIsland = map.Ice


	local detectiveCFrame = CFrame.new(4849, 15, 720);
	local progress = commF:InvokeServer("DressrosaQuestProgress");

	if (not progress.TalkedDetective) then
		tweento(detectiveCFrame);
		wait(1);
		commF:InvokeServer("DressRosaQuestProgress", "Detective");
		return startDressrosa();
	end

	local door = iceIsland.Door
	if (not progress.UsedKey) then
		tweento(ice.CFrame * CFrame.new(0, 150, 0));
		tweento(door.CFrame);
		local key = LocalPlayer.Backpack:FindFirstChild("Key") or char:FindFirstChild("Key");
		key.Parent = char
		firetouchinterest(key.Handle, door, 0);
		wait();
		firetouchinterest(key.Handle, door, 1);
		wait(1);
		return startDressrosa();
	end

	if (not progress.KilledIceBoss) then
		tweento(door.CFrame);
		local thread = coroutine.running();
		local oldT = settings.auto_training.buso
		local old = settings.fast_attack
		settings.auto_training.buso = true
		settings.fast_attack = true
		attackNPCs(thread, "Ice Admiral", true);
		coroutine.yield();
		settings.fast_attack = old
		settings.auto_training.buso = oldT
		return startDressrosa();
	end

	if (commF:InvokeServer("DressrosaQuestProgress", "Dressrosa") ~= 0) then
		tweento(detectiveCFrame);
		commF:InvokeServer("DressRosaQuestProgress", "Detective");
		wait(1);
		tweento(CFrame.new(-1169, 7, 1725));
		commF:InvokeServer("DressRosaQuestProgress", "Dressrosa");
		wait(1);
	end
	commF:InvokeServer("TravelDressrosa");
end

local getbladehits;
for i, v in pairs(getgc(true)) do
    if (type(v) == "table") then
        local bladeHits = rawget(v, "getBladeHits");
        if (bladeHits and type(bladeHits) == "function") then
            local old = bladeHits
            v.getBladeHits = function(...)
                if (settings.auto_farm and settings.target_only_attacking) then
                    local torsos = {}
                    for i2 , v2 in pairs(attackingNPCs) do
                        local torso = findFirstChild(v2, "UpperTorso");
                        if (not table.find(sKillingNPCs, v2) and torso and (characterPos - torso.Position).Magnitude < 30) then
                            torsos[#torsos + 1] = torso
                        end
                    end
                    return torsos;
                end
                return old(...);
            end
            break;
        end
    end
end

UserInputService.InputEnded:Connect(function(key, GPE)
    local keyString = string.split(tostring(key.KeyCode), ".")[3]
    if (not GPE and keys[keyString]) then
        keys[keyString] = false
    end
end);

UserInputService.InputBegan:Connect(function(key, GPE)
    local keyString = string.split(tostring(key.KeyCode), ".")[3]
    if (not GPE) then
        keys[keyString] = true
    end
end);

local mainWindow = UILibrary:CreateWindow("Fate Hub", "Blox Fruits", Color3.fromRGB(100, 0, 255));

local main = mainWindow:Tab("Main");
local autoFarm = main:Section("Auto Farm");


autoFarm:Toggle("Enable AutoFarm", settings.auto_farm, function(callback)
    settings.auto_farm = callback
end);
autoFarm:Toggle("Fast Attack", settings.fast_attack, function(callback)
    settings.fast_attack = callback
end);
autoFarm:Toggle("Only Attack NPC Target", settings.target_only_attacking, function(callback)
	settings.target_only_attacking = callback
end);
autoFarm:Toggle("Auto Skill", settings.auto_skill, function(callback)
	settings.auto_skill = callback
end);

autoFarm:Toggle("Auto Boss", settings.auto_farm_boss, function(callback)
	settings.auto_farm_boss = callback
	if (not callback) then
		force = true
		wait(.1);
		force = false
	end
end);
local enemiesT = {};
for i, enemy in pairs(enemies:GetChildren()) do
	if (string.find(enemy.Name, "Boss")) then
		enemiesT[#enemiesT + 1] = enemy.Name
	end
end
settings.boss_name = enemiesT[1]
local drop = autoFarm:Dropdown("Select Boss", enemiesT[1], enemiesT, function(callback)
	settings.boss_name = callback
end);
enemies.ChildAdded:Connect(function(enemy)
	table.clear(enemiesT);
	for i, enemy in pairs(enemies:GetChildren()) do
		if (string.find(enemy.Name, "Boss")) then
			enemiesT[#enemiesT + 1] = enemy.Name
		end
	end
	drop:UpdateList(enemiesT);
end);
enemies.ChildRemoved:Connect(function(enemy)
	table.clear(enemiesT);
	for i, enemy in pairs(enemies:GetChildren()) do
		if (string.find(enemy.Name, "Boss")) then
			enemiesT[#enemiesT + 1] = enemy.Name
		end
	end
	drop:UpdateList(enemiesT);
end);

autoFarm:Slider("Distance Y", 5, 20, settings.offsets.Y, function(callback)
	settings.offsets.Y = callback
end);

local tools = {};
local tooltips = {"Melee", "Blox Fruit", "Sword", "Gun"}
local updateWeapons = function()
	table.clear(tools);

	for i, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if (tool:IsA("Tool") and table.find(tooltips, tool.ToolTip)) then
			tools[#tools + 1] = tool.Name
		end
	end
	for i, tool in pairs(LocalPlayer.Character:GetChildren()) do
		if (tool:IsA("Tool")  and table.find(tooltips, tool.ToolTip)) then
			tools[#tools + 1] = tool.Name
		end
	end
	LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
		if (table.find(tooltips, tool.ToolTip) and not table.find(tools, tool.Name)) then
			tools[#tools + 1] = tool.Name
		end
	end);
	LocalPlayer.Backpack.ChildRemoved:Connect(function(tool)
		if (table.find(tooltips, tool.ToolTip) and table.find(tools, tool.Name)) then
			table.remove(tools, table.find(tools, tool.Name));
		end
	end);
end


updateWeapons();
settings.tool = tools[1]
settings.auto_skill_wep = tools[1]
local weapons = autoFarm:Dropdown("Weapon", tools[1], tools, function(callback)
	settings.tool = callback
end);

local autoWorld = main:Section("Auto World");

autoWorld:Toggle("Auto Second Sea", settings.auto_third, function(callback)
	settings.auto_second = callback
	local lvl = getLevel();
	if (lvl >= 700) then
		startDressrosa();
	end
end);

local autoSkill = main:Section("Auto Skill")
local autoSkillWeapon = autoSkill:Dropdown("Auto Skill Weapon", tools[1], tools, function(callback)
	settings.auto_skill_wep = callback
end);
autoSkill:Button("Refresh Weapons", function()
	updateWeapons();
	weapons:UpdateList(tools);
	autoSkillWeapon:UpdateList(tools);
end);

local skillButtons = { "Z", "X", "C", "V", "F" };

for i, skillButton in pairs(skillButtons) do
	autoSkill:Toggle("Auto " .. skillButton, false, function(callback)
		settings.auto_skills[skillButton] = callback
	end);
end

autoSkill:Slider("Health Percentage", 0, 100, settings.auto_skill_percentage, function(callback)
	settings.auto_skill_percentage = callback
end);
autoSkill:Slider("Skill Hold Time", 0, 5, 0, function(callback)
	settings.auto_skill_hold = callback
end);

local autoStats = main:Section("Auto Stats");

local statAmount = 50
autoStats:Slider("Stat Amount", 0, 500, statAmount, function(callback)
	statAmount = callback
end);
local statsAuto = {
	Melee = false,
	Defense = false,
	Sword = false,
	Gun = false,
	["Demon Fruit"] = false
};

local points = LocalPlayer:WaitForChild("Data"):WaitForChild("Points")
for stat, enabled in pairs(statsAuto) do
	autoStats:Toggle(stat, enabled, function(callback)
		statsAuto[stat] = callback
	end);
end

task.spawn(function()
	while true do
		local currentPoints = points.Value
		local sharing = 0
		for stat, enabled in pairs(statsAuto) do
			if (enabled) then
				sharing += 1
			end
		end
		local sharedAmount = sharing == 0 and 1 or math.min(currentPoints, statAmount) / sharing
		if (currentPoints >= statAmount) then
			for stat, enabled in pairs(statsAuto) do
				if (enabled) then
					commF:InvokeServer("AddPoint", stat, math.floor(sharedAmount));
				end
			end
		end
		points:GetPropertyChangedSignal("Value"):Wait();
	end
end);

local autoTrain = main:Section("Auto Train");

autoTrain:Toggle("Auto Train Buso", false, function(callback)
	settings.auto_training.buso = callback
end);
autoTrain:Toggle("Auto Train Observation", false, function(callback)
	settings.auto_training.observation = callback
end);

autoTrain:SetRight();

task.spawn(function()
	while true do
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
		char:WaitForChild("Humanoid");
		char:WaitForChild("HumanoidRootPart");
		wait(.1);
		if (settings.auto_training.buso) then
			if (not char:FindFirstChild("HasBuso")) then
				commF:InvokeServer("Buso");
			end
		end
		if (settings.auto_training.observation and HasTag("Ken")) then
			local observationManager = getrenv()._G.OM;
			if (observationManager and not observationManager.active) then
				observationManager:setActive(true);
				commE:FireServer("Ken", true);
			end
		end
		wait();
	end
end);

local misc = main:Section("Misc");
misc:SetRight();

local checkSnipe = function(fruit)
	if (settings.auto_snipe_fruits and fruit:IsA("Tool")) then
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
		local root = char:WaitForChild("HumanoidRootPart");
		local handle = fruit:WaitForChild("Handle");
		firetouchinterest(handle, root, 0);
		wait();
		firetouchinterest(handle, root, 1);
		wait();
		fruit.Parent = LocalPlayer.Backpack
		if (settings.auto_snipe_fruits) then
			commF:InvokeServer("StoreFruit", fruit.Name);
		end
	end
end

Workspace.ChildAdded:Connect(function(child)
	checkSnipe(child);
end);
misc:Toggle("Auto Snipe Fruits", settings.auto_snipe_fruits, function(callback)
	settings.auto_snipe_fruits = callback
	if (callback) then
		for i, child in pairs(Workspace:GetChildren()) do
			checkSnipe(child);
		end
	end
end);
misc:Toggle("Auto Store Fruits", settings.auto_store_fruits, function(callback)
	settings.auto_store_fruits = callback
	if (callback) then
		for i, fruit in pairs(LocalPlayer.Backpack:GetChildren()) do
			if (fruit.ToolTip == "") then
				commF:InvokeServer("StoreFruit", fruit.Name);
			end
		end
	end
end);

misc:Button("Do Saber Quest", function()
	startSaberQuest();
end);

local mainGui = LocalPlayer.PlayerGui.Main

misc:Button("Open Inventory", function()
	mainGui.Inventory.Visible = true
end);
misc:Button("Open Fruit Inventory", function()
	mainGui.FruitInventory.Visible = true
end);
misc:Button("Set Nearest Spawn", function()
	for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
end);

local collectChests = function(safe)
	for i, v in pairs(Workspace:GetChildren()) do
		if (string.sub(v.Name, 1, 5) == "Chest") then
			local char = LocalPlayer.Character
			if (not char) then
				char = LocalPlayer.CharacterAdded:Wait();
			end
			local root = char:WaitForChild("HumanoidRootPart", 10);
			if (not root) then
				break;
			end
			repeat
				root.CFrame = v.CFrame
				char:BreakJoints();
				for i1 = 1, 3 do
					wait();
					firetouchinterest(v, root, 0);
					wait();
					firetouchinterest(v, root, 1);
				end
				wait(.1);
			until v.Parent ~= Workspace or not root or not char;
			wait(.1);
		end
	end
end
misc:Button("Collect All Chests", function(callback)
	collectChests();
end);

local codes = {
    exp2x = {
        "Enyu_is_Pro",
        "Magicbus",
        "Sub2Fer999",
        "Starcodeheo",
        "JCWK",
        "KittGaming",
        "Bluxxy",
        "Sub2OfficialNoobie",
        "TheGreatAce",
        "Axiore",
        "Sub2Daigrock",
        "TantaiGaming",
        "StrawHatMaine",
        "SUB2GAMERROBOT_EXP1"
    },
    statReset = {
        "Sub2UncleKizaru",
        "SUB2GAMERROBOT_RESET1",
    }
}

local currentCode = ""
local codes_ = {};
for codeType, codes2 in pairs(codes) do
	for i, code in pairs(codes2) do
		codes_[#codes_ + 1] = string.format("%s (%s)", codeType, code);
	end
end
local dropdown = misc:Dropdown("Code to redeem", currentCode, codes_, function(callback)
	local code = string.match(callback, "%b()")
	currentCode = string.sub(code, 2, #code - 1);
	print(currentCode);
end);

misc:Button("Redeem Code", function()
	print(remotes.Redeem:InvokeServer(currentCode));
end);


local teleports = mainWindow:Tab("Teleports");

local islands = teleports:Section("Island Teleports");

local setspawnTP = false
islands:Toggle("Set Spawn TP", false, function(callback)
	setspawnTP = callback
end);

local mapLocations = Workspace._WorldOrigin.Locations:GetChildren();
local islands_ = {};

for i, location in pairs(mapLocations) do
	if (location:IsA("Part")) then
		local locationName = location.Name
		if (islands_[locationName]) then
			local n = 2
			local newName
			repeat
				newName = string.format("%s (%s)", locationName, n);
				n += 1
			until not islands_[newName]
			locationName = newName
		end

		local pos = location.CFrame
		islands_[locationName] = pos * CFrame.new(0, 150, 0);
		islands:Button(locationName, function()
			if (setspawnTP) then
				local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
				local root = char:WaitForChild("HumanoidRootPart");
				root.CFrame = pos
				char:BreakJoints();
				for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
			else
				tweento(pos);
			end
		end);
	end
end

local Seas = teleports:Section("Seas");
Seas:Button("First Sea", function()
	commF:InvokeServer("TravelMain");
end);
Seas:Button("Second Sea", function()
	commF:InvokeServer("TravelDressrosa");
end)
Seas:Button("Third Sea", function()
	commF:InvokeServer("TravelZou");
end);
Seas:SetRight();

local servers = teleports:Section("Servers");

local regions = { "Random", "United States, Florida", "Japan, Tokyo", "Hong Kong, Central and Western District", "United States, California", "Germany, Hesse", "Singapore, North West", "Netherlands, North Holland", "United States, Illinois", "United Kingdom, England", "United States, Oregon", "Poland, Mazovia", "United States, New York", "United States, Texas", "France, ÃŽle-de-France", "United States, New Jersey" };
local region = "Random"
local method = "Client"

local bfServerhop = function(region, largest)
	local filteredServers = {};
	local smallestCount = math.huge
	local server = nil
	local largestCount = 0


	local serverBrowser = ReplicatedStorage:FindFirstChild("__ServerBrowser");
	for i = 1, 100 do
		local data = serverBrowser:InvokeServer(i);
		for jobId, serverData in pairs(data) do
			if (region == "Random" or serverData.Region == region) then
				filteredServers[#filteredServers + 1] = serverData
				filteredServers[#filteredServers].id = jobId

				if (not largest and serverData.Count == 1) then -- quick
					Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId);
					break;
				elseif (largest and serverData.Count == 11) then
					Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId);
					break;
				end

				if (largest) then
					if (serverData.Count > largestCount) then
						largestCount = serverData.Count
						server = serverData
					end
				else
					if (serverData.Count < smallestCount) then
						smallestCount = serverData.Count
						server = serverData
					end
				end
			end
		end
	end

	Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id);
end

servers:Dropdown("Server Hop Method", method, {"Client", "Server"}, function(callback)
	method = callback
end);
servers:Dropdown("Region", region, regions, function(callback)
	region = callback
end);
servers:Button("Server Hop Largest", function()
	if (method == "Server") then
		bfServerhop(region, true);
	else
		serverhop("Desc");
	end
end);
servers:Button("Server Hop Smallest", function()
	if (method == "Server") then
		bfServerhop(region, false);
	else
		serverhop("Asc");
	end
end);
servers:Button("Rejoin Server", function()
	Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId);
end);
servers:SetRight();

local lp = mainWindow:Tab("LocalPlayer");

local Character = lp:Section("Character");


local walkspeedSlider = Character:Slider("WalkSpeed", 0, 300, 16, function(callback)
	settings.character.walkspeed = callback
end);
local jumppowerSlider = Character:Slider("JumpPower", 0, 500, 50, function(callback)
	settings.character.jumppower = callback
end);
Character:Slider("Fly Speed", 0, 10, 5, function(callback)
	settings.character.fly = callback
end);

Character:Toggle("Apply WalkSpeed", false, function(callback)
	settings.character.speeding = callback
end);
Character:Toggle("Apply JumpPower", false, function(callback)
	settings.character.jumping = callback
	if (not callback) then
		LocalPlayer.Character.Humanoid.JumpPower = 50
	end
end);
Character:Toggle("Fly Character", false, function(callback)
    if (callback) then
        flyChar(currentCamera, LocalPlayer.Character.HumanoidRootPart, 5);
    else
        settings.character.flying = false
    end
end);
Character:Toggle("Noclip", false, function(callback)
	settings.character.noclip = true
end);

local Players = lp:Section("Players");

local Other = lp:Section("Other");

local cooldownT = {};
Other:Toggle("No Geppo Cooldown", false, function(callback)
	settings.cooldowns.geppo = callback
end);
Other:Toggle("No Dodge Cooldown", false, function(callback)
	settings.cooldowns.dodge = callback
end);
Other:Toggle("No Soru Cooldown", false, function(callback)
	settings.cooldowns.soru = callback
end);
Other:Toggle("Infinite Energy", false, function(callback)
	settings.character.energy = callback
end);
Other:Toggle("Infinite Geppo", false, function(callback)
	settings.character.infgeppo = callback
end);

local refresh = function(character)
	local geppoScript = character:WaitForChild("Geppo");
	local dodgeScript = character:WaitForChild("Dodge");
	local soruScript = character:WaitForChild("Soru");
	energyValue = character:WaitForChild("Energy");


	cooldownT.geppo = debug.getupvalue(debug.getproto(getscriptclosure(geppoScript), 2, true)[1], 8);
	cooldownT.dodge = debug.getupvalue(debug.getproto(getscriptclosure(dodgeScript), 3, true)[1], 2);
	cooldownT.soru = debug.getupvalue(debug.getproto(getscriptclosure(soruScript), 1, true)[1], 9);
end

LocalPlayer.CharacterAdded:Connect(function(character)
	local root = character:WaitForChild("HumanoidRootPart");

	if (settings.character.flying) then
        flyChar(currentCamera, LocalPlayer.Character.HumanoidRootPart, 5);
	end

	if (settings.character.noclip) then

	end

	refresh(character);
end);

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
refresh(character);

local Shop = mainWindow:Tab("Shop");

local Fruits = Shop:Section("Fruits");
Fruits:Button("Open Fruit Shop", function()
	mainGui.FruitShop.Visible = true
end);
Fruits:Button("Buy Cousin Fruit", function()
	print(commF:InvokeServer("Cousin", "Buy"));
end);

local abilitiesInfo = {
	{ "10,000", "BuyHaki", "Geppo" },
	{ "25,000", "BuyHaki", "Buso" },
	{ "100,000", "BuyHaki", "Soru" },
	{ "750,000", "KenTalk", "Buy" },
}

local Abilities = Shop:Section("Abilities");

for i, abilityInfo in ipairs(abilitiesInfo) do
	Abilities:Button(string.format("Buy %s ($%s)", abilityInfo[3] == "Buy" and "Observation Haki" or abilityInfo[3], abilityInfo[1]), function()
		commF:InvokeServer(unpack(abilityInfo, 2));
	end);
end

local stylesInfo = {
	{ "150,000", "Black Leg" },
	{ "500,000", "Electro" },
	{ "750,000", "Fishman Karate" },
	{ "2,500,000", "Sharkman  Karate" },
	{ "2,500,000", "Death Step" },
	{ "3,000,000", "Electric Claw" },
	{ "3,000,000", "Dragon Talon" },
	{ "3,000,000", "Super Human" },
	{ "(f)1,500", "Dragon Breath" }
}
local Styles = Shop:Section("Fighting Styles");

for i, styleInfo in ipairs(stylesInfo) do
	Styles:Button(string.format("Buy %s (%s)", styleInfo[2], styleInfo[1]), function()
		commF:InvokeServer("Buy" .. styleInfo[2]:gsub(" ", ""));
	end);
end

local swordsInfo = {
	{ "1,000", "Katana" },
	{ "1,000","Cutlass" },
	{ "12,000", "Dual Katana" },
	{ "25,000", "Iron Mace" },
	{ "60,000", "Triple Katana" },
	{ "100,000", "Pipe" },
	{ "400,000", "Dual-Headed Blade" },
	{ "750,000", "Soul Cane" },
	{ "1,200,000", "Bisento" },
};

local Swords = Shop:Section("Swords");

for i, swordInfo in ipairs(swordsInfo) do
	Swords:Button(string.format("Buy %s (%s)", swordInfo[2], swordInfo[1]), function()
		commF:InvokeServer("BuyItem", swordInfo[2]);
	end);
end
Swords:Button("Buy Pole V2 ((f)5,000)", function()
	commF:InvokeServer("ThunderGodTalk");
end);

local gunsInfo = {
	{ "5,000", "Slingshot" },
	{ "8,000", "Musket" },
	{ "30,000", "Refined Slingshot" },
	{ "65,000", "Refined Flintlock" },
	{ "100,500", "Flintlock" },
}
local Guns = Shop:Section("Guns");

for i, gunInfo in pairs(gunsInfo) do
	Guns:Button(string.format("Buy %s (%s)", gunInfo[2], gunInfo[1]), function()
		commF:InvokeServer("BuyItem", gunInfo[2]);
	end);
end
Guns:Button("Buy Kabucha ((f)1,500", function()
	commF:InvokeServer("BlackbeardReward", "Slingshot", "2");
end);

local accessoriesInfo = {
	{ "50,000", "Black Cape" },
	{ "150,000", "Swordsman Hat" },
	{ "500,000", "Tomoe Ring" }
};
local Accessories = Shop:Section("Accessories");

for i, accessoryInfo in pairs(accessoriesInfo) do
	Accessories:Button(string.format("Buy %s (%s)", accessoryInfo[2], accessoryInfo[1]), function()
		commF:InvokeServer("BuyItem", accessoryInfo[2]);
	end);
end

local Visuals = mainWindow:Tab("Visuals");

task.spawn(function()
	while true do
		if (settings.auto_farm) then
			print("running new quest!!");
			doQuest();
		end

		if (settings.auto_farm_boss) then
			print("running new boss!!");
			doBoss();
			print("end!");
		end

		wait();
	end
end)

while true do
	for t, v in pairs(cooldownT) do
		if (settings.cooldowns[t]) then
			rawset(v, "LastUse", 0);
		end
	end
	if (settings.character.infgeppo) then
		local char = LocalPlayer.Character
		if (char) then
			local hum = char:FindFirstChild("Humanoid");
			if (hum) then
				for i, v in pairs(getconnections(hum.StateChanged)) do
					if (v.Function and debug.getconstants(v.Function)[3] == "Landed") then
						debug.setupvalue(v.Function, 1, 0);
					end
				end
			end
		end
	end
	if (settings.character.energy) then
		energyValue.Value = energyValue.MaxValue
	end

    wait();
end