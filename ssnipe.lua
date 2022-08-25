local HttpService = game:GetService("HttpService");
local TeleportService = game:GetService("TeleportService");
local Players = game:GetService("Players");

local getPlayerThumbnail = function(id)
    return Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
end

local function decode(json)
    return HttpService:JSONDecode(json);
end
local function encode(json)
    return HttpService:JSONEncode(json);
end

local function reload(response, func, ...)
    if (response.StatusCode ~= 200) then
        if (response.StatusCode == 404) then
            return error(string.format("404"));
        else
            return func(...);
        end
    end
end

local function batchRequest(data)
    local response = syn.request({
        Url = "https://thumbnails.roblox.com/v1/batch",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Method = "POST",

        Body = encode(data)
    });

    reload(response, batchRequest, data);

    return response.Body;
end

local function getServers(id, cursor)
    local fullurl = "https://games.roblox.com/v1/games/".. id .."/servers/Public?limit=100"
    if cursor then
        fullurl ..= "&cursor=".. cursor
    end

    local response = syn.request({
        Url = fullurl
    });
    reload(response, getServers, id, cursor);

    return response.Body;
end

local function getThumbnails(tokens)
    for i, token in pairs(tokens) do
        tokens[i] = {
            requestId = string.format("0:%s:AvatarHeadshot:150x150:png:regular", token),
            type = "AvatarHeadShot",
            targetId = 0,
            token = token,
            format = "png",
            size = "150x150"
        }
    end

    local response = batchRequest(tokens);

    local good, decoded = pcall(decode, response);

    if (good) then
        return decoded;
    else
        return {};
    end
end


local cursor;

while true do
    
end