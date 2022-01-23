local format     = string.format;
local gsub       = string.gsub;
local consolep   = rconsoleprint;
local get_gc     = getgc;
local getfn      = game.GetFullName;
local append     = appendfile;
local Serializer = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotDSF/leopard/main/rbx/leopard-syn.lua"))();

if not isfile("jbspy.txt") then writefile("jbspy.txt", ""); end;

local function GetLocal(index)
  for i,v in pairs(get_gc(true)) do
    if type(v) == "table" and rawget(v, index) then
      return v;
    end;
  end;
end;

local function printf(...) 
  append("jbspy.txt", gsub(format(...), "%\27%[%d+m", ""));
  return consolep(format(...));
end;

consolep("Jailbreak Spy v1.0.1 (Fates Hub Development Tool)\nOutput is automatically being saved to: \27[32m\"jbspy.txt\"\27[0m\n\n");

local Network = GetLocal("FireServer");
local Backup = Network.FireServer;
local Blacklisted = {};

for i,v in pairs(GetLocal("hems")) do
  if type(v) == "function" and #debug.getconstants(v) > 1 then
    if debug.getconstant(v, 1) == "MakeSpring" then
      printf("Blacklisted \"%s\" due to it being a spam remote.\n\n", i);
      Blacklisted[i] = true;
      break;
    end;
  end;
end;

Network.FireServer = function(self, key, ...)
  if not Blacklisted[key] then
    printf("Remote Called\nCaller: \"%s\"\nArguments: %s\n\n", getfn(getcallingscript()), Serializer.Serialize({ key, ... }));
  end;
  return Backup(self, key, ...);
end;

getgenv().RemoveSpy = function() 
  Network.FireServer = Backup;
end;
