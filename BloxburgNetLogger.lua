local ser = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotDSF/leopard/main/rbx/leopard-syn.lua"))();
local net = filtergc("table", { Keys = {"net"} }, true);

local b;
b = hookfunction(net.net.FireServer, function(self, request, ...) 
    if typeof(request) ~= "table" then
        return b(self, request, ...);
    end;

    if rawget(request, "Type") == "LookDir" then
        return b(self, request, ...);
    end;

    rconsolewarn(string.format("[BLOXBURG->PACKET]: network.FireServer(%s)\n", ser.Serialize(request)));
    return b(self, request, ...)
end);
