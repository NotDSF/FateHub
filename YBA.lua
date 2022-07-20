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
local living = Workspace:FindFirstChild("Living");
local locations = Workspace:FindFirstChild("Locations");

local mainWindow = UILibrary:CreateWindow("Fate Hub", "Your Bizzare Adventure", Color3.fromRGB(100, 0, 255));

local visuals = mainWindow:Tab("Visuals");
local visualsLocations = visuals:Section("Locations");


for i, location in pairs(locations:GetChildren()) do
    local locationesp = Visuals:Add(location);
    local text = locationesp:AddText(location.Name, {
        Visible = false
    });
    visualsLocations:Toggle(location.Name, false, function(callback)
        text.Visible = callback
    end);
end


local visualsMobs = visuals:Section("Mobs");
local mobs = {};
for i, mob in pairs(living:GetChildren()) do
    if (not mobs[mob.Name] and mob:FindFirstChild("AIHandler")) then
        local mobesp = Visuals:Add(mob.Head);
        local text = mobesp:AddText(mob.Name, {
            Visible = false
        });
        mobs[mob.Name] = {[mob]=text};
        visualsMobs:Toggle(mob.Name, false, function(callback)
            for i, v in pairs(mobs[mob.Name]) do
                v.Visible = callback
            end
        end);
    elseif (mobs[mob.Name]) then
        local mobesp = Visuals:Add(mob.Head);
        local text = mobesp:AddText(mob.Name, {
            Visible = false
        });
        table.insert(mobs[mob.Name], {[mob]=text});
    end
end