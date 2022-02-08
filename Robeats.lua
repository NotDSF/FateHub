local Options = {
    Perfect = .5,
    Okay = 4,
    Great = 2
}

local Option = Options.Perfect

task.spawn(function()
    local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))();
    local UI = Lib.Load({
        Title = "Fates Hub",
        Style = 1,
        SizeX = 400,
        SizeY = 400,
        Theme = "Dark"
    });

    local AutoPlay = UI.New({
        Title = "AutoPlay"
    });

    AutoPlay.Dropdown({
        Text = "Option",
        Callback = function(Value)
            Option = Options[Value]
        end,
        Options = {
            "Perfect",
            "Great",
            "Okay",
        }
    });
end);

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer
local WorkspaceChildren = game:GetService("Workspace"):GetChildren();

local Parent;
local Character;
for Index = 1, #WorkspaceChildren do
    local Child = WorkspaceChildren[Index]
    local ChildChildren = Child:GetChildren();
    for Index2, Child2 in pairs(ChildChildren) do
        local Humanoid = Child2:FindFirstChild("Humanoid");
        if (Humanoid and Humanoid.DisplayName == LocalPlayer.DisplayName) then
            Parent = Child
            Character = Child2
            break;
        end
    end
end

local Notes = {
    A = { IsHolding = false; LastPressed = tick() };
    S = { IsHolding = false; LastPressed = tick() };
    D = { IsHolding = false; LastPressed = tick() };
    F = { IsHolding = false; LastPressed = tick() };
}

local Children = Parent:GetChildren();
for Index = 1, #Children do
    local Child = Children[Index]
    local ChildChildren = Child:GetChildren();
    if (#ChildChildren == 9) then
        for Index2 = 1, #ChildChildren do
            local ChildofChild = ChildChildren[Index2]
            if (tostring(ChildofChild.BrickColor) == "Fire Yellow") then
                if ((ChildofChild.Position - Character.HumanoidRootPart.Position).Magnitude <= 20) then
                    if (not Notes.A.Position) then
                        Notes.A.Position = ChildofChild.Position
                    elseif (not Notes.S.Position) then
                        Notes.S.Position = ChildofChild.Position
                    elseif (not Notes.D.Position) then
                        Notes.D.Position = ChildofChild.Position
                    elseif (not Notes.F.Position) then
                        Notes.F.Position = ChildofChild.Position
                    else
                        break;
                    end
                end
            end
        end
    end
end

local keypress = function(Key)
    keypress(Key);
end
local keyrelease = function(Key)
    keyrelease(Key);
end

_G.LOL = game.ItemChanged:Connect(function(Item, Prop)
    local ClassName = Item.ClassName
    if (string.find(ClassName, "Adornment") and Prop == "CFrame") then
        local IsSphere = ClassName == "SphereHandleAdornment"
        local Transparency = Item.Transparency
        local Position = Item.CFrame.Position
        local now = tick();
        local A, D, S, F = Notes.A, Notes.D, Notes.S, Notes.F

        if ((A.Position - Position).Magnitude <= Option and now - A.LastPressed > .05) then --0x41
            if (A.IsHolding and Transparency == 0.5) then
                keyrelease(0x41);
                A.IsHolding = false
            elseif (Transparency == 0) then
                keypress(0x41);
                if (IsSphere) then
                    A.IsHolding = true
                else
                    keyrelease(0x41);
                end
                A.LastPressed = now
            end
        end
        if ((D.Position - Position).Magnitude <= Option and now - D.LastPressed > .05) then --0x44
            if (D.IsHolding and Transparency == 0.5) then
                keyrelease(0x44);
                D.IsHolding = false
            elseif (Transparency == 0) then
                keypress(0x44);
                if (IsSphere) then
                    D.IsHolding = true
                else
                    keyrelease(0x44);
                end
                D.LastPressed = now
            end
        end
        if ((S.Position - Position).Magnitude <= Option and now - S.LastPressed > .05) then --0x53
            if (S.IsHolding and Transparency == 0.5) then
                keyrelease(0x53);
                S.IsHolding = false
            elseif (Transparency == 0) then
                keypress(0x53);
                if (IsSphere) then
                    S.IsHolding = true
                else
                    keyrelease(0x53);
                end
                S.LastPressed = now
            end
        end
        if ((F.Position - Position).Magnitude <= Option and now - F.LastPressed > .05) then --0x46
            if (F.IsHolding and Transparency == 0.5) then
                keyrelease(0x46);
                F.IsHolding = false
            elseif (Transparency == 0) then
                keypress(0x46);
                if (IsSphere) then
                    F.IsHolding = true
                else
                    keyrelease(0x46);
                end
                F.LastPressed = now
            end
        end
    end
end);