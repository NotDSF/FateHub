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
    auto_farm = {
        ben = false
    }
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


local protectInstance = function(instance)
    protectedInstances[#protectedInstances + 1] = instance
end

local tp_to = function(pos)
    local char = LocalPlayer.Character
    if (char) then
        local root = char.HumanoidRootPart
        if (settings.auto_farm.legit) then
            local hum = char:FindFirstChildOfClass("Humanoid");
            if (hum) then
                hum:MoveTo(pos.Position);
                hum.MoveToFinished:Wait();
            end
        else
            root.CFrame = pos
        end
        return true;
    end
    return false
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

local Environment = Workspace:WaitForChild("Environment");
local Locations = Environment:WaitForChild("Locations");

local network = filtergc("table", {
    Keys = {"net"}
}, true);

local JobHandler = filtergc("table", {
    Keys = {"GoToWork"}
}, true);
local LoadingHandler = filtergc("table", {
    Keys = {"ShowLoading", "HideLoading"}
}, true);

local fireServer = function(t)
    local getRemote = debug.getupvalue(network.net.FireServer, 4);
    local remote = getRemote(t.Type);
    t.Type = nil
    remote:FireServer(t);
end

local jobsLoaded = false
local jobsLoadedEvent = Instance.new("BindableEvent");
local BensIceCreamEvent = Instance.new("BindableEvent");
local BloxyBurgersCashierEvent = Instance.new("BindableEvent");
local MechanicEvent = Instance.new("BindableEvent");

restorefunction(JobHandler.CreateChatBubble);
restorefunction(LoadingHandler.ShowLoading);
restorefunction(LoadingHandler.HideLoading);

local oldCreateChatBubble;
oldCreateChatBubble = hookfunction(JobHandler.CreateChatBubble, function(...)
    local ret = oldCreateChatBubble(...);
    if (settings.auto_farm.ben) then
        BensIceCreamEvent:Fire(ret);
    elseif (settings.auto_farm.buger_cashier) then
        BloxyBurgersCashierEvent:Fire(ret);
    elseif (settings.auto_farm.mechanic) then
        MechanicEvent:Fire(ret);
    end

    return ret;
end);
local oldShowLoading;
oldShowLoading = hookfunction(LoadingHandler.ShowLoading, function(...)
    jobsLoaded = false
    print("loading...");
    return oldShowLoading(...);
end);

local oldHideLoading;
oldHideLoading = hookfunction(LoadingHandler.HideLoading, function(...)
    jobsLoaded = true
    jobsLoadedEvent:Fire()
    return oldHideLoading(...);
end);

local locations = workspace.Environment.Locations
local getLocation = function(location)
    return locations:FindFirstChild(location);
end

local requireModule = function(moduleName)
    local _JobHandler = LocalPlayer.PlayerGui.MainGUI.Scripts.JobHandler
    return require(_JobHandler:FindFirstChild(moduleName));
end

local flavours = {
    ["Sunrise"] = {"Strawberry", { 936, 13, 1051 }},
    ["Pine Cone"]  =  {"Chocolate", { 933, 13, 1052 }},
    ["Pastel yellow"] = {"Vanilla", { 932, 13, 1051 }}
};
local toppings = {
    ["rbxassetid://2132313170"] = {"Sprinkles", { 927, 13, 1047 }},
    ["rbxassetid://455528053"] = {"Caramel", { 927, 13, 1045 }},
    ["rbxassetid://22360490"] = {"Nuts", { 927, 13, 1043 }}
};

jobsLoadedEvent.Event:Connect(function() 
    wait(5);
    if not settings.auto_farm.fisherman or JobHandler:GetJob() ~= "HutFisherman" then return end;

    local hum = LocalPlayer.Character.Humanoid;
    hum:MoveTo(Vector3.new(1059.00927734375, 13.679994583129883, 1080.4874267578125))
    hum.MoveToFinished:Wait();

    hum:MoveTo(Vector3.new(1020.7296142578125, 13.629997253417969, 1069.344970703125))
    hum.MoveToFinished:Wait();

    hum:MoveTo(Vector3.new(1018.0104370117188, 13.629997253417969, 1078.9429931640625))
    hum.MoveToFinished:Wait();

    while JobHandler:IsWorking() and settings.auto_farm.fisherman do
        wait()
        fireServer({
            State = true,
            Type = "UseFishingRod",
            Pos = Vector3.new(1014.0109252929688, 8, 1090.2320556640625)
        });
    
        local tnow = os.clock();
        repeat wait() until game.Players.LocalPlayer.Character["Fishing Rod"].Bobber.Position.Y == 7;
        
        fireServer({
            State = false,
            Type = "UseFishingRod",
            Time = os.clock() - tnow
        });
    
        wait(2);
    end;
end);

BensIceCreamEvent.Event:Connect(function(chatBar)
    if (not jobsLoaded) then
        print("loading job...");
        jobsLoadedEvent.Event:Wait();
        wait(1);
        print("loaded");
    end

    local char = LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart");
    if (not root) then end
    local cupsPosition = CFrame.new(929, 13, 1050);
    if ((root.Position - cupsPosition.Position).Magnitude > 5) then
        tp_to(cupsPosition);
        wait(.5);
    end

    local BensIceCream = requireModule("BensIceCreamSeller");

    fireServer({
        Type = "TakeIceCreamCup"
    });

    task.wait(.1);

    local descendants = chatBar:GetDescendants();
    local ingredients = {};

    for i, item in pairs(descendants) do
        if (item.Name == "Icon" and string.match(item.Parent.Name, "%s")) then
            ingredients[#ingredients + 1] = item
        end
    end

    local fillFlavour = debug.getproto(BensIceCream.StartShift, 2, true)[1]
    local fillTopping = debug.getproto(BensIceCream.StartShift, 3, true)[1]

    local legit = settings.auto_farm.legit

    local toppingData;

    for i, item in pairs(ingredients) do
        if (item.Image == "rbxassetid://2132263837") then -- ice cream flavour
            local ImageColor3 = item.ImageColor3
            local Brick = BrickColor.new(ImageColor3);
            for color, flavour in pairs(flavours) do
                if (color == tostring(Brick)) then
                    tp_to(CFrame.new(unpack(flavour[2])));

                    debug.setupvalue(fillFlavour, 3, flavour[1]);
                    debug.setupvalue(fillFlavour, 5, flavour[1]);
                    local doFillFlavour = select(3, fillFlavour());

                    if (doFillFlavour) then
                        print("Adding " .. flavour[1]);
                        debug.setupvalue(doFillFlavour, 3, flavour[1]);
                        debug.setupvalue(doFillFlavour, 5, flavour[1]);
                        doFillFlavour();
                    end
                end
            end
        elseif (toppings[item.Image]) then
            toppingData = toppings[item.Image]
        end
        if (not legit) then
            wait(.1);
        end
    end

    if (toppingData) then
        tp_to(CFrame.new(unpack(toppingData[2])));

        debug.setupvalue(fillTopping, 3, toppingData[1]);
        debug.setupvalue(fillTopping, 5, toppingData[1]);
        local doFillTopping = select(3, fillTopping());
        if (doFillTopping) then
            print("Adding " .. toppingData[1]);
            debug.setupvalue(doFillTopping, 3, toppingData[1]);
            debug.setupvalue(doFillTopping, 5, toppingData[1]);
            if (not legit) then
                wait(.5);
            end
            doFillTopping();
        else
            print("fail");
        end
    end

    local customerModel = chatBar:FindFirstAncestor("BensIceCreamCustomer");
    local customerRoot = customerModel:WaitForChild("HumanoidRootPart");
    tp_to(customerRoot.CFrame * CFrame.new(0, 0, -5));
    if (not legit) then
        root.CFrame *= CFrame.Angles(0, math.pi, 0);
    end

    local workStations = getLocation("BensIceCream").CustomerTargets:GetChildren();
    local workStation;
    for i , _workStation in pairs(workStations) do
        if (_workStation.Occupied.Value == customerModel) then
            workStation = _workStation
            break;
        end
    end
    fireServer({
        Type = "JobCompleted",
        Workstation = workStation
    });
end);

local foods = {
    ["333557004"] = "Deluxe",
    ["333556924"] =  "Classic",
    ["333556968"] = "Double",
    ["333557058"] = "Fries",
    ["333557087"] = "Cola"
};

BloxyBurgersCashierEvent.Event:Connect(function(chatBar)
    if (not jobsLoaded) then
        print("loading...");
        jobsLoadedEvent.Event:Wait();
        wait(1);
        print("loaded");
    end

    local workStations = getLocation("BloxyBurgers").CashierWorkstations

    local character = LocalPlayer.Character
    local root = character:FindFirstChild("HumanoidRootPart");
    local customerModel = chatBar:FindFirstAncestor("BloxyBurgersCustomer");
    local customerRoot = customerModel:FindFirstChild("HumanoidRootPart");

    local closest, mag = nil, math.huge
    for i, v in pairs(workStations:GetChildren()) do
        local magnitude = (customerRoot.Position - v:GetBoundingBox().Position).Magnitude
        if (mag > magnitude) then
            closest = v
            mag = magnitude
        end
    end

    local legit = settings.auto_farm.legit

    if (legit) then
        local humanoid = character:FindFirstChild("Humanoid");
        if (humanoid) then
            humanoid:MoveTo(closest:GetBoundingBox().Position);
            humanoid.MoveToFinished:Wait();
        end
    else
        root.CFrame = closest:GetBoundingBox();
        root.CFrame *= CFrame.Angles(0, math.pi, 0);
    end
    

    local descendants = chatBar:GetDescendants();
    local ingredients = {};

    for i, item in pairs(descendants) do
        if (item.Name == "Icon" and string.match(item.Parent.Name, "%s")) then
            ingredients[#ingredients + 1] = item
        end
    end

    local doAction = filtergc("function", {
        Name = "doAction"
    }, true);

    debug.setupvalue(doAction, 2, closest);


    for i, ingredient in pairs(ingredients) do
        local assetLink = ingredient.Image
        local asset = string.match(assetLink, "rbxassetid://(%w+)");
        local food = foods[asset]
        print(assetLink, asset, food);
        if (food) then
            doAction(food);
            wait(legit and .5 or .1);
        end
    end
    doAction("Done");
end);


local colours = {
    ["Black"] = "Black",
    ["Magenta"] = "Purple",
    ["Bright red"] = "Red",
    ["Lime green"] = "Green"
};

MechanicEvent.Event:Connect(function(chatBar)
    if (not jobsLoaded) then
        print("loading...");
        jobsLoadedEvent.Event:Wait();
        wait(1);
        print("loaded");
    end

    local descendants = chatBar:GetDescendants();
    local ingredients = {};

    for i, item in pairs(descendants) do
        if (item.Name == "Icon" and string.match(item.Parent.Name, "%s")) then
            ingredients[#ingredients + 1] = item
        end
    end

    local done = filtergc("function", {
        Name = "done"
    });

    local legit = settings.auto_farm.legit
    if (legit) then
        wait(1);
    end

    local paintingEquipment = workspace.Environment.Locations.MikesMotors.PaintingEquipment

    for i, item in pairs(ingredients) do
        if (item.Image == "rbxassetid://2132263837") then
            local ImageColor3 = item.ImageColor3
            local brick = BrickColor.new(ImageColor3);
            local paint = colours[tostring(brick)]
            tp_to(CFrame.new(1175, 13, 387));
            print(paint, brick);
            if (paint) then
                fireServer({
                    Type = "TakePainter",
                    Object = paintingEquipment:FindFirstChild(paint)
                });
            end
        elseif (item.Image == "rbxassetid://602099154") then

        end
    end

    for i, d in pairs(done) do
        d();
    end
end);


local mainWindow = UILibrary:CreateWindow("Fate Hub", "Bloxburg 1", Color3.fromRGB(100, 0, 255));

local main = mainWindow:Tab("Main");
local autoFarm = main:Section("Auto Work");

-- auto job only works for when you are by yourself, will fix later

autoFarm:Toggle("Auto IceCream", settings.auto_farm.ben, function(callback)
    if (callback) then
        JobHandler:GoToWork("BensIceCreamSeller");
    end
    settings.auto_farm.ben = callback
end);

autoFarm:Toggle("Auto Fisherman", settings.auto_farm.fisherman, function(callback) 
    if callback then
        JobHandler:GoToWork("HutFisherman");
    end;
    settings.auto_farm.fisherman = callback;
end)

autoFarm:Toggle("Auto BloxyBurger", settings.auto_farm.buger_cashier, function(callback)
    if (callback) then
        task.spawn(JobHandler.GoToWork, JobHandler, "BloxyBurgersCashier");
        jobsLoadedEvent.Event:Wait();
        local displays = workspace.Environment.Locations.BloxyBurgers.Displays
        local character = LocalPlayer.Character
        local root = character:FindFirstChild("HumanoidRootPart");
        if (root) then
            root.CFrame = displays:FindFirstChild("Support", true).CFrame
            root.CFrame *= CFrame.Angles(math.pi, math.pi, 0);
            root.CFrame *= CFrame.new(0, -3, -5);
        end
    end
    settings.auto_farm.buger_cashier = callback
end);

autoFarm:Toggle("Legit Work", settings.auto_farm.legit, function(callback)
    settings.auto_farm.legit = callback
end);

autoFarm:Button("End Shift", function()
    fireServer({
        Type = "EndShift"
    });
    JobHandler:SetWorking(nil);
end);

