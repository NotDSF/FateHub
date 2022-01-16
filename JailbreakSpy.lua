--[[
  Fates Hub private development script (DO NOT LEAK);
  v1.0.0
--]]

local config   = { spaces = 4 };
local format   = string.format;
local gsub     = string.gsub;
local consolep = rconsoleprint;
local get_gc   = getgc;
local getfn    = game.GetFullName;
local append   = appendfile;
local Serialize; 

-- Serializer shit (didn't make it a loadstring because it will have shit I don't need to release on my github)
do 
  local sub      = string.sub;
  local rep      = string.rep;
  local byte     = string.byte;
  local match    = string.match;
  local info     = debug.getinfo;
  local huge     = math.huge; -- just like your mother
  local Type     = typeof;
  local Pairs    = pairs;
  local Assert   = assert;
  local Tostring = tostring;
  local concat   = table.concat;
  local Tab      = rep(" ", config.spaces or 4);
  
  local function formatFunction(func)
    if info then -- Creates function prototypes
      local proto = info(func);
      local params = {};
  
      if proto.nparams then
        for i=1, proto.nparams do
          params[i] = format("p%d", i);
        end;
        if proto.isvararg then
          params[#params+1] = "...";
        end;
      end;
  
      return format("function %s(%s) end", proto.namewhat or proto.name or "", concat(params, ", "));
    end;
    return "function () end"; -- we cannot create a prototype
  end;
  
  local function formatString(str) 
    local Pos = 1;
    local String = {};
    while Pos <= #str do
      local Key = sub(str, Pos, Pos);
      if Key == "\n" then
        String[Pos] = "\\n";
      elseif Key == "\t" then
        String[Pos] = "\\t";
      elseif Key == "\"" then
        String[Pos] = "\\\"";
      else
        local Code = byte(Key);
        if Code < 32 or Code > 126 then
          String[Pos] = format("\\%d", Code);
        else
          String[Pos] = Key;
        end;
      end;
      Pos = Pos + 1;
    end;
    return concat(String);
  end;
  
  -- We can do a little trolling and use this for booleans too
  local function formatNumber(numb) 
    if numb == huge then
      return "math.huge";
    elseif numb == -huge then
      return "-math.huge";
    end;
    return Tostring(numb);
  end;
  
  local function formatIndex(idx, scope)
    local indexType = Type(idx);
    local finishedFormat = idx;
  
    if indexType == "string" then
      if match(idx, "[^_%a%d]+") then
        finishedFormat = format("\27[32m\"%s\"\27[0m", formatString(idx));
      else
        return idx;
      end;
    elseif indexType == "table" then
      scope = scope + 1;
      finishedFormat = Serialize(idx, scope);
    elseif indexType == "number" or indexType == "boolean" then
      finishedFormat = format("\27[33m%s\27[0m", formatNumber(idx));
    end;
  
    return format("[%s]", finishedFormat);
  end;
  
  Serialize = function(tbl, scope) 
    Assert(Type(tbl) == "table", "invalid argument #1 to 'Serialize' (table expected)");
  
    scope = scope or 0;
  
    local Serialized = {}; -- For performance reasons
    local scopeTab = rep(Tab, scope);
    local scopeTab2 = rep(Tab, scope+1);
  
    local tblLen = 0;
    for i,v in Pairs(tbl) do
      local formattedIndex = formatIndex(i, scope);
      local valueType = Type(v);
      local SerializeIndex = #Serialized + 1;
      if valueType == "string" then -- Could of made it inline but its better to manage types this way.
        Serialized[SerializeIndex] = format("%s%s = \27[32m\"%s\"\27[0m,\n", scopeTab2, formattedIndex, formatString(v));
      elseif valueType == "number" or valueType == "boolean" then
        Serialized[SerializeIndex] = format("%s%s = \27[33m%s\27[0m,\n", scopeTab2, formattedIndex, formatNumber(v));
      elseif valueType == "table" then
        Serialized[SerializeIndex] = format("%s%s = %s,\n", scopeTab2, formattedIndex, Serialize(v, scope+1));
      elseif valueType == "userdata" then
        Serialized[SerializeIndex] = format("%s%s = newproxy(),\n", scopeTab2, formattedIndex);
      elseif valueType == "Instance" then
        Serialized[SerializeIndex] = format("%s%s = %s,\n", scopeTab2, formattedIndex, getfn(v));
      elseif valueType == "function" then
        Serialized[SerializeIndex] = format("%s%s = %s,\n", scopeTab2, formattedIndex, formatFunction(v));
      else
        Serialized[SerializeIndex] = format("%s%s = \"%s\" -- %s,\n", scopeTab2, formattedIndex, Tostring(v), valueType); -- Unsupported types.
      end;
      tblLen = tblLen + 1; -- # messes up with nil values
    end;
  
    -- Remove last comma
    local lastValue = Serialized[#Serialized];
    if lastValue then
      Serialized[#Serialized] = sub(lastValue, 0, -3) .. "\n";
    end;
  
    if tblLen > 0 then
      if scope < 1 then
        return format("{\n%s}", concat(Serialized));  
      else
        return format("{\n%s%s}", concat(Serialized), scopeTab);
      end;
    else
      return "{}";
    end;
  end;
end;

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

consolep("Jailbreak Spy v1.0.0 (Fates Hub Development Tool)\nOutput is automatically being saved to: \27[32m\"jbspy.txt\"\27[0m\n\n");

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
    printf("Remote Called\nCaller: \"%s\"\nArguments: %s\n\n", getfn(getcallingscript()), Serialize({ key, ... }));
  end;
  return Backup(self, key, ...);
end;

getgenv().RemoveSpy = function() 
  Network.FireServer = Backup;
end;
