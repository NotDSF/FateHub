if (_G.Bruh)then _G.Bruh:Disconnect();end

local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Client = Workspace:FindFirstChild("Client");

local RunningTasks = {}
_G.Bruh = Client.ChildAdded:Connect(function(Child)
    if (Child.Name == "Cube_Mesh") then
        table.insert(RunningTasks, Child);
    end
end);