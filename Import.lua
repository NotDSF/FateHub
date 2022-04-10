local Import do
    local request = syn.request;
    local format = string.format;
    local HttpService = game.HttpService;
    local decode = syn.crypt.base64.decode;

    Import = function(name) 
        local Response = request({
            Url = format("https://api.github.com/repos/NotDSF/FateHub/contents/%s", name),
            Headers = {
                Authorization = "bearer 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"
            }
        });

        local ResponseBody = HttpService.JSONDecode(HttpService, Response.Body);
        local res, err = loadstring(decode(ResponseBody.content));
        if not res then
            return err;
        end;

        return res();
    end;
end;
