local uilib = loadfile("UILibrary.lua")();
local Window = uilib:CreateWindow('<font color="rgb(0, 0, 255)">FH</font> v3', 'test', Color3.fromRGB(255, 50, 150))

local tab1 = Window:Tab('test1')
local tab2 = Window:Tab('a')
local Section1 = tab1:Section('test')
local Section2 = tab1:Section('a')
local Section3 = tab2:Section('Rage')

local Toggle = Section1:Toggle('test', false, function(a)
    print(a)
end)
local Toggle2 = Section1:Toggle('fh winning?', true, function() end)
local Toggle3 = Section1:Toggle('yes', true, function() end)

local Dropdown = Section1:Dropdown('test', 'default', {'ab', 'ac'}, function(a) 
      print(a) 
end)
Section1:Slider('yooo', -50, 50, 0, function(v) 
      print(v) 
end)
local Slider = Section1:Slider('yooo', -50, 50, 0, function(v) 
      print(v) 
end, true)
local Colorthing = Section1:Colorpicker('Colorpicker', Color3.fromRGB(0, 0, 255), function(a)
      print(a)
end)
local Button = Section1:Button('what', function()
      print('ok buton') 
end)
local Keybind = Section1:Keybind('Keybind', nil, function(a)
      print('Set to: ', a) 
end, function() 
      print('tess') 
end)
local Userint = Section1:UserInput('User input', 'def', function(a) print(a) end)
Section1:Button('Copy config', function()
    setclipboard(Window:GenerateConfig())
end)

Toggle:UpdateToggle(true)
Toggle:UpdateTitle('UpdatedTitle')
Toggle2:Colorpicker(Color3.new(0, 1, 0), function(color)
    print("wow", color);
end);
Toggle3:Keybind(Enum.UserInputType.MouseButton2, function(callback)
    print("wow x2", callback);
end)
Dropdown:UpdateList({'new', 'list'})
Dropdown:UpdateTitle('New title')
Slider:UpdateMin(0)
Slider:UpdateMax(100)
Slider:UpdateValue(25)
Slider:UpdateTitle('teat325251')
Colorthing:UpdateColor(Color3.fromRGB(0, 255, 0))
Colorthing:UpdateTitle('etate')
Button:UpdateTitle('button new thing')
Keybind:UpdateTitle('etate')
Keybind:UpdateBind(Enum.KeyCode.Tab)

Window:LoadConfig('{"test1":{"test":{"User input":{"CurrentInput":"this is a config","Type":"UserInput","UpdateInput":null,"UpdateTitle":null},"Colorpicker":{"Type":"Colorpicker","UpdateTitle":null,"ColorTrack":null,"ColorTable":{"R":1,"B":0.6857142448425293,"G":0},"UpdateColor":null},"fh winning?":{"Type":"Toggle","Toggle":true,"UpdateToggle":null,"UpdateTitle":null},"Keybind":{"KeyTrack":null,"KeyStr":"Enum.KeyCode.Equals","UpdateBind":null,"UpdateTitle":null,"Type":"Keybind"},"test":{"Type":"Dropdown","UpdateSelected":null,"Selected":"new","UpdateList":null,"UpdateTitle":null},"yooo":{"UpdateValue":null,"Type":"Slider","UpdateMax":null,"UpdateTitle":null,"SlideValue":35.5,"UpdateMin":null}},"a":[]},"a":{"Rage":[]}}')