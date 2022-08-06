local network = filtergc("table", {
    Keys = {"net"}
}, true);

local JobHandler = filtergc("table", {
    Keys = {"GoToWork"}
}, true);

local BensIceCream = filtergc("table", {
    Keys = {"GetOrderPhrase", "AddCustomer", "ShiftRadius"}
}, true);

JobHandler:GoToWork("BensIceCreamSeller");


local ChatBarEvent = Instance.new("BindableEvent");

restorefunction(JobHandler.CreateChatBubble);

local old;
old = hookfunction(JobHandler.CreateChatBubble, function(...)
    local ret = old(...);
    ChatBarEvent:Fire(ret);
    return ret;
end);


ChatBarEvent.Event:Connect(function(chatBar)
    network.net:FireServer({
        Type = "TakeIceCreamCup"
    });

    local descendants = chatBar:GetDescendants();
    local ingredients = {};

    for i, item in pairs(descendants) do
        if (item.Name == "Icon" and string.match(item.Parent.Name, "%s")) then
            stuff[#stuff + 1] = item
        end
    end

    for i, item in pairs(ingredients) do
        if (item.Image == "rbxassetid://2132263837") then -- ice cream flavour
            
        end
    end
end);