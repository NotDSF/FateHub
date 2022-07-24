if getgenv().fah then
    getgenv().fah:Destroy()
end

local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local Mouse = game.Players.LocalPlayer:GetMouse()

local Instance_new = Instance.new
local UDim2_new = UDim2.new
local UDim2_fromOffset = UDim2.fromOffset
local fromRGB = Color3.fromRGB
local Colorscheme = Color3.fromRGB(255, 50, 150)

-- Config
local SectionSpace = 10
local KeybindClose = Enum.KeyCode.BackSlash

local UiLib = {}
local Tabs = {}

local function UiElements(Section, SectionTable, Ret)
    local SectionalY = 15

    local function newColorPicker(withToggle, parent, name, Def, Callback)
        local Main = Instance_new("TextButton")
        local Title = Instance_new('TextLabel')
        local StatusColor = Instance_new('Frame')

        local Colorpicker = Instance_new('Frame')
        local Colors = Instance_new('ImageLabel')
        local ColorsGradient = Instance_new('UIGradient')
        local HueSlider = Instance_new('Frame')
        local HueGradient = Instance_new('UIGradient')
        local ChosenColor = Instance_new('Frame')
        local Divider = Instance_new('Frame')
        local Divider2 = Instance_new('Frame')
        local Hex = Instance_new('Frame')
        local HexTitle = Instance_new('TextLabel')
        local HexValue = Instance_new('TextBox')
        local C = Instance_new('Frame')
        local CValue = Instance_new('TextBox')
        local Close = Instance_new('TextButton')
        local Rainbow = Instance_new('TextButton')

        if (not withToggle) then
            Main.BackgroundColor3 = fromRGB(17, 17, 17)
            Main.AutoButtonColor = false
            Main.BorderColor3 = fromRGB(17, 17, 17)
            Main.Position = UDim2_fromOffset(13, SectionalY)
            Main.Size = UDim2_fromOffset(200, 20)
            Main.Text = ''
            Main.Parent = Section

            Title.BackgroundTransparency = 1
            Title.Size = UDim2_fromOffset(200, 20)
            Title.Font = Enum.Font.SourceSans
            Title.Text = name
            Title.TextColor3 = fromRGB(200, 200, 200)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Main
        end

        StatusColor.BackgroundColor3 = Def or fromRGB(255, 255, 255)
        StatusColor.BorderColor3 = fromRGB(40, 40, 40)
        StatusColor.Position = UDim2_fromOffset(185, 3)
        StatusColor.Size = UDim2_fromOffset(15, 15)
        StatusColor.Parent = withToggle and parent or Main

        Colorpicker.BackgroundColor3 = fromRGB(20, 20, 20)
        Colorpicker.BorderColor3 = fromRGB(40, 40, 40)
        Colorpicker.Size = UDim2_fromOffset(210, 237)
        Colorpicker.Visible = false
        Colorpicker.Parent = Section.Parent.Parent.Parent

        Colors.BackgroundColor3 = fromRGB(255, 255, 255)
        Colors.BorderColor3 = fromRGB(20, 20, 20)
        Colors.Position = UDim2_fromOffset(5, 5)
        Colors.Size = UDim2_fromOffset(174, 175)
        Colors.Image = 'http://www.roblox.com/asset/?id=8863257882'
        Colors.Parent = Colorpicker

        --ColorsGradient.Rotation = 180
        ColorsGradient.Parent = Colors

        HueSlider.BackgroundColor3 = fromRGB(255, 255, 255)
        HueSlider.BorderColor3 = fromRGB(20, 20, 20)
        HueSlider.Position = UDim2_fromOffset(185, 5)
        HueSlider.Size = UDim2_fromOffset(20, 175)
        HueSlider.Parent = Colorpicker

        HueGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1/6, fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(2/6, fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.5, fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4/6, fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(5/6, fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, fromRGB(255, 0, 0))
        }
        HueGradient.Rotation = -90
        HueGradient.Parent = HueSlider

        ChosenColor.BackgroundColor3 = Def or fromRGB(255, 255, 255)
        ChosenColor.BorderColor3 = fromRGB(40, 40, 40)
        ChosenColor.Position = UDim2_fromOffset(185, 185)
        ChosenColor.Size = UDim2_fromOffset(20, 20)
        ChosenColor.Parent = Colorpicker

        Hex.BackgroundColor3 = fromRGB(20, 20, 20)
        Hex.BorderColor3 = fromRGB(20, 20, 20)
        Hex.Position = UDim2_fromOffset(5, 185)
        Hex.Size = UDim2_fromOffset(174, 20)
        Hex.Parent = Colorpicker

        HexTitle.BackgroundTransparency = 1
        HexTitle.Size = UDim2_new(0.2, 0, 1, 0)
        HexTitle.Font = Enum.Font.SourceSansSemibold
        HexTitle.Text = 'Hex'
        HexTitle.TextColor3 = fromRGB(200, 200, 200)
        HexTitle.TextSize = 14
        HexTitle.TextXAlignment = Enum.TextXAlignment.Left
        HexTitle.Parent = Hex

        HexValue.BackgroundColor3 = fromRGB(20, 20, 20)
        HexValue.BorderColor3 = fromRGB(40, 40, 40)
        HexValue.Position = UDim2_new(0.2, 0, 0, 0)
        HexValue.Size = UDim2_new(0.8, 0, 1, 0)
        HexValue.ClearTextOnFocus = false
        HexValue.Font = Enum.Font.SourceSans
        HexValue.Text = '  #' ..  (Def:ToHex() or '  #FFFFFF')
        HexValue.TextColor3 = fromRGB(175, 175, 175)
        HexValue.TextSize = 14
        HexValue.TextXAlignment = Enum.TextXAlignment.Left
        HexValue.Parent = Hex

        C.BackgroundColor3 = fromRGB(20, 20, 20)
        C.BorderColor3 = fromRGB(20, 20, 20)
        C.Size = UDim2_fromOffset(45, 15)
        C.Parent = Colorpicker

        CValue.BackgroundColor3 = fromRGB(20, 20, 20)
        CValue.BorderColor3 = fromRGB(40, 40, 40)
        CValue.Size = UDim2_new(1, 0, 1, 0)
        CValue.ClearTextOnFocus = false
        CValue.Font = Enum.Font.SourceSans
        CValue.TextColor3 = fromRGB(175, 175, 175)
        CValue.TextSize = 14

        local RC, RValue = C:Clone(), CValue:Clone()
        local GC, GValue = C:Clone(), CValue:Clone()
        local BC, BValue = C:Clone(), CValue:Clone()

        RC.Position = UDim2_fromOffset(5, 215)
        RC.Parent = Colorpicker
        RValue.Text = Def and math.floor(Def.R) or '255'
        RValue.TextColor3 = fromRGB(255, 0, 0)
        RValue.Parent = RC

        GC.Position = UDim2_fromOffset(55, 215)
        GC.Parent = Colorpicker
        GValue.Text = Def and math.floor(Def.G) or '255'
        GValue.TextColor3 = fromRGB(0, 255, 0)
        GValue.Parent = GC

        BC.Position = UDim2_fromOffset(105, 215)
        BC.Parent = Colorpicker
        BValue.Text = Def and math.floor(Def.B) or '255'
        BValue.TextColor3 = fromRGB(0, 0, 255)
        BValue.Parent = BC

        Rainbow.BackgroundColor3 = fromRGB(25, 25, 25)
        Rainbow.BorderColor3 = fromRGB(40, 40, 40)
        Rainbow.Position = UDim2_fromOffset(155, 215)
        Rainbow.Size = UDim2_fromOffset(50, 15)
        Rainbow.Font = Enum.Font.SourceSans
        Rainbow.Text = "Rainbow"
        Rainbow.TextColor3 = fromRGB(175, 175, 175)
        Rainbow.TextSize = 14.000
        Rainbow.Parent = Colorpicker

        C:Destroy()

        local Ret = {Type = 'Colorpicker', ColorTrack = Def or fromRGB(255, 255, 255), ColorTable = {
            R = Def and Def.R or 255,
            G = Def and Def.G or 255,
            B = Def and Def.B or 255
        }}

        local V2N = Vector2.new
        local clamp = math.clamp
        local floor = math.floor
        local fromHSV = Color3.fromHSV

        local StoredValues = {Hue = 0, Sat = 0, Val = 1}

        local function UpdateColor(H, S, V)
            --local H, S, V = Clr:ToHSV()
            local Clr = fromHSV(H, S, V);

            StoredValues.Hue = H; StoredValues.Sat = S; StoredValues.Val = V

            ChosenColor.BackgroundColor3 = Clr
            ColorsGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, fromHSV(H, 1, 1))
            }

            RValue.Text = floor(Clr.R * 255)
            GValue.Text = floor(Clr.G * 255)
            BValue.Text = floor(Clr.B * 255)

            HexValue.Text = '  #' .. Clr:ToHex();

            task.spawn(Callback, Clr);
            StatusColor.BackgroundColor3 = Clr
            ColorTrack = Clr
        end
        UpdateColor(Def:ToHSV());

        local rainbowEnabled = false
        RunService.RenderStepped:Connect(function()
            if (rainbowEnabled) then
                local hue = (tick() / 5) % 1
                UpdateColor(hue, StoredValues.Sat, StoredValues.Val);
            end
        end);

        Colors.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPosition = Colors.AbsolutePosition
                local ColorsSize = Colors.AbsoluteSize

                local Val = clamp(Mouse.Y - AbsPosition.Y, 0, ColorsSize.Y) / ColorsSize.Y
                local Sat = clamp(Mouse.X - AbsPosition.X, 0, ColorsSize.X) / ColorsSize.X

                UpdateColor(StoredValues.Hue, Sat, 1 - Val)

                local MouseMove = Mouse.Move:Connect(function()
                    local Val = clamp(Mouse.Y - AbsPosition.Y, 0, ColorsSize.Y) / ColorsSize.Y
                    local Sat = clamp(Mouse.X - AbsPosition.X, 0, ColorsSize.X) / ColorsSize.X
                    print(Sat,Val);
                    UpdateColor(StoredValues.Hue, Sat, 1 - Val);
                end)

                local EndedCon = nil
                EndedCon = Colors.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        EndedCon:Disconnect()
                    end
                end)
            end
        end)

        HueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local Position, Size = HueSlider.AbsolutePosition.Y, HueSlider.AbsoluteSize.Y

                local Hue = clamp(Mouse.Y - Position,  0, Size) / Size
                UpdateColor(Hue, StoredValues.Sat, StoredValues.Val)

                local MouseMove = Mouse.Move:Connect(function()
                    local Hue = clamp(Mouse.Y - Position,  0, Size) / Size
                    UpdateColor(Hue, StoredValues.Sat, StoredValues.Val);
                end)

                local EndedCon = nil
                EndedCon = HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        EndedCon:Disconnect()
                    end
                end)
            end
        end)

        RValue.FocusLost:Connect(function(isEnter)
            local Int = tostring(RValue.Text)
            if isEnter and Int then
                local CC = fromHSV(StoredValues.Hue, StoredValues.Sat, StoredValues.Sat)
                UpdateColor(Color3.new(clamp(Int, 0, 255) / 255, CC.G, CC.B):ToHSV())
            end
        end)

        GValue.FocusLost:Connect(function(isEnter)
            local Int = tostring(GValue.Text)
            if isEnter and Int then
                local CC = fromHSV(StoredValues.Hue, StoredValues.Sat, StoredValues.Sat)
                UpdateColor(Color3.new(CC.R, clamp(Int, 0, 255) / 255, CC.B):ToHSV())
            end
        end)

        BValue.FocusLost:Connect(function(isEnter)
            local Int = tostring(BValue.Text)
            if isEnter and Int then
                local CC = fromHSV(StoredValues.Hue, StoredValues.Sat, StoredValues.Sat)
                UpdateColor(Color3.new(CC.R, CC.G, clamp(Int, 0, 255) / 255):ToHSV())
            end
        end)

        HexValue.FocusLost:Connect(function(isEnter)
            local Hex = Color3.fromHex(string.gsub(HexValue.Text, '#', ''))
            if isEnter and Hex then UpdateColor(Hex:ToHSV()) end
        end)

        Close.MouseButton1Click:Connect(function()
            Colorpicker.Visible = false
        end)

        Rainbow.MouseButton1Click:Connect(function()
            rainbowEnabled = not rainbowEnabled
        end)

        if (withToggle) then
            StatusColor.InputBegan:Connect(function(key)
                if (key.UserInputType == Enum.UserInputType.MouseButton1) then
                    Colorpicker.Visible = not Colorpicker.Visible
                    Colorpicker.Position = UDim2_fromOffset(Mouse.X + 5, Mouse.Y);
                end
            end);
        else
            Main.MouseButton1Click:Connect(function()
                Colorpicker.Visible = not Colorpicker.Visible
                Colorpicker.Position = UDim2_fromOffset(Mouse.X + 5, Mouse.Y)
            end);
        end

        Main.MouseEnter:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(225, 225, 225)
            }):Play()
        end)

        Main.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(200, 200, 200)
            }):Play()
        end)
        function Ret:UpdateColor(newColor)
            UpdateColor(newColor)
            StatusColor.BackgroundColor3 = newColor
            Ret.ColorTable = {
                R = newColor.R,
                G = newColor.G,
                B = newColor.B
            }
        end
        function Ret:UpdateTitle(newTitle) Title.Text = newTitle end

        if (not withToggle) then
            SectionalY = SectionalY + 20
            Section.Size = Section.Size + UDim2_fromOffset(0, 20)
            SectionTable[name] = Ret
        end

        return Ret;
    end

    local function newKeybind(withToggle, parent, Name, DefaultKey, setCallback, onInput)
        local Keybind = Instance_new('TextButton')
        local Title = Instance_new('TextLabel')
        local CurrentKey = Instance_new('TextLabel')

        if (not withToggle) then
            Keybind.BackgroundColor3 = fromRGB(17, 17, 17)
            Keybind.BorderColor3 = fromRGB(17, 17, 17)
            Keybind.AutoButtonColor = false
            Keybind.Position = UDim2_fromOffset(13, SectionalY)
            Keybind.Size = UDim2_fromOffset(200, 15)
            Keybind.Text = ''
            Keybind.Parent = Section

            Title.BackgroundTransparency = 1
            Title.Size = UDim2_fromOffset(165, 15)
            Title.Font = Enum.Font.SourceSans
            Title.Text = Name
            Title.TextColor3 = fromRGB(200, 200, 200)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Keybind
        end

        CurrentKey.BackgroundTransparency = 1
        CurrentKey.Position = UDim2_fromOffset(120, 0)
        CurrentKey.Size = UDim2_fromOffset(80, 15)
        CurrentKey.Font = Enum.Font.SourceSans
        CurrentKey.Text = DefaultKey and string.format('[%s]', string.split(tostring(DefaultKey), '.')[3]) or 'none'
        CurrentKey.TextColor3 = Colorscheme
        CurrentKey.TextSize = 14
        CurrentKey.TextXAlignment = Enum.TextXAlignment.Right
        CurrentKey.Parent = withToggle and parent or Keybind

        local Ret = {Type = 'Keybind', KeyTrack = DefaultKey, KeyStr = tostring(DefaultKey)}
        local MouseInputs = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3}

        UserInputService.InputBegan:Connect(function(input, gp)
            if input.KeyCode == Ret.KeyTrack and not gp then 
                onInput()
            end
        end)

        CurrentKey.InputBegan:Connect(function(key)
            if (key.UserInputType ~= Enum.UserInputType.MouseButton1) then return; end

            CurrentKey.Text = "[...]"
            local InputBegan = nil
            InputBegan = UserInputService.InputBegan:Connect(function(input, gp)
                if input.UserInputType == Enum.UserInputType.Keyboard and not gp then
                    Ret.KeyStr = tostring(input.KeyCode)
                    task.spawn(setCallback, input.KeyCode)
                    CurrentKey.Text = string.format('[%s]', string.split(tostring(input.KeyCode), '.')[3])
                    InputBegan:Disconnect()
                    task.wait()
                    Ret.KeyTrack = input.KeyCode
                elseif table.find(MouseInputs, input.UserInputType) and not gp then
                    Ret.KeyStr = tostring(input.UserInputType)
                    task.spawn(setCallback, input.UserInputType)
                    CurrentKey.Text = string.format('[%s]', string.split(tostring(input.UserInputType), '.')[3])
                    InputBegan:Disconnect()
                    task.wait()
                    Ret.KeyTrack = input.UserInputType
                end
            end)
        end)

        Keybind.MouseEnter:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(225, 225, 225)
            }):Play()
        end)

        Keybind.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(200, 200, 200)
            })
        end)

        function Ret:UpdateBind(newBind)
            Ret.KeyTrack = newBind
            Ret.KeyStr = tostring(newBind)
            task.spawn(setCallback, newBind)
            CurrentKey.Text = string.format('[%s]', string.split(tostring(newBind), '.')[3])
        end
        function Ret:UpdateTitle(newTitle) Title.Text = newTitle end


        if (not withToggle) then
            SectionTable[Name] = Ret
            SectionalY = SectionalY + 15
            Section.Size = Section.Size + UDim2_fromOffset(0, 15)
        end

        return Ret
    end

    function Ret:Toggle(Name, Default, Callback)
        local ToggleMain = Instance_new('TextButton')
        local Title = Instance_new('TextLabel')
        local Status = Instance_new('Frame')

        ToggleMain.BackgroundColor3 = fromRGB(17, 17, 17)
        ToggleMain.BorderColor3 = fromRGB(17, 17, 17)
        ToggleMain.AutoButtonColor = false
        ToggleMain.Position = UDim2_fromOffset(13, SectionalY)
        ToggleMain.Size = UDim2_fromOffset(200, 20)
        ToggleMain.Text = ''
        ToggleMain.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Position = UDim2_fromOffset(22, 0)
        Title.Size = UDim2_fromOffset(135, 20)
        Title.Font = Enum.Font.SourceSans
        Title.Text = Name
        Title.TextColor3 = Default and fromRGB(225, 225, 225) or fromRGB(150, 150, 150)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = ToggleMain

        Status.BackgroundColor3 = Default and Colorscheme or fromRGB(22, 22, 22)
        Status.BorderColor3 = fromRGB(40, 40, 40)
        Status.Position = UDim2_fromOffset(0, 3)
        Status.Size = UDim2_fromOffset(15, 15)
        Status.Parent = ToggleMain

        local Ret = {Type = 'Toggle', Toggle = Default}
        local EnterTween = TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = fromRGB(200, 200, 200)})

        Title.InputBegan:Connect(function(key)
            if (key.UserInputType == Enum.UserInputType.MouseButton1) then
                Toggle = not Toggle
                task.spawn(Callback, Toggle)
                Ret.Toggle = Toggle

                TweenService:Create(Status, TweenInfo.new(0.2), {
                    BackgroundColor3 = (Ret.Toggle and Colorscheme or fromRGB(22, 22, 22))
                }):Play()
                TweenService:Create(Title, TweenInfo.new(0.2), {
                    TextColor3 = (Ret.Toggle and fromRGB(225, 225, 225) or fromRGB(150, 150, 150))
                }):Play()
            end
        end);
        Status.InputBegan:Connect(function(key)
            if (key.UserInputType == Enum.UserInputType.MouseButton1) then
                Toggle = not Toggle
                task.spawn(Callback, Toggle)
                Ret.Toggle = Toggle
                TweenService:Create(Status, TweenInfo.new(0.2), {
                    BackgroundColor3 = (Ret.Toggle and Colorscheme or fromRGB(22, 22, 22))
                }):Play()
                TweenService:Create(Title, TweenInfo.new(0.2), {
                    TextColor3 = (Ret.Toggle and fromRGB(225, 225, 225) or fromRGB(150, 150, 150))
                }):Play()
            end
        end);

        local function ToggleSet(set)
            if set ~= nil then
                Ret.Toggle = set
            else
                Ret.Toggle = not Ret.Toggle
            end
            task.spawn(Callback, Ret.Toggle)

            TweenService:Create(Status, TweenInfo.new(0.2), {
                BackgroundColor3 = (Ret.Toggle and Colorscheme or fromRGB(22, 22, 22))
            }):Play()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = (Ret.Toggle and fromRGB(225, 225, 225) or fromRGB(150, 150, 150))
            }):Play()
        end

        function Ret:UpdateToggle(T) ToggleSet(T) end
        function Ret:UpdateTitle(newTitle) Title.Text = newTitle end

        function Ret:Colorpicker(default, callback)
            return newColorPicker(true, ToggleMain, nil, default, callback);
        end

        function Ret:Keybind(default, callback, onInput)
            return newKeybind(true, ToggleMain, nil, default, callback, onInput);
        end

        ToggleMain.MouseEnter:Connect(function()
            EnterTween:Play()
        end)
        ToggleMain.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Ret.Toggle and fromRGB(225, 225, 225) or fromRGB(150, 150, 150)}):Play()
        end)

        SectionTable[Name] = Ret
        SectionalY = SectionalY + 20
        Section.Size = Section.Size + UDim2_fromOffset(0, 20)

        return Ret;
    end
    function Ret:Dropdown(Name, Default, List, Callback, excludeConfig)
        local DropdownFrame = Instance_new('Frame')
        local Drop = Instance_new('ScrollingFrame')
        local Title = Instance_new('TextLabel')
        local DropButton = Instance_new('TextButton')

        DropdownFrame.BackgroundColor3 = fromRGB(17, 17, 17)
        DropdownFrame.BorderColor3 = fromRGB(17, 17, 17)
        DropdownFrame.Position = UDim2_fromOffset(13, SectionalY)
        DropdownFrame.Size = UDim2_fromOffset(200, 35)
        DropdownFrame.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(200, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = Name
        Title.TextColor3 = fromRGB(200, 200, 200)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = DropdownFrame

        DropButton.BackgroundColor3 = fromRGB(20, 20, 20)
        DropButton.BorderColor3 = fromRGB(40, 40, 40)
        DropButton.AutoButtonColor = false
        DropButton.Position = UDim2_fromOffset(1, 20)
        DropButton.Size = UDim2_fromOffset(200, 15)
        DropButton.Font = Enum.Font.SourceSansSemibold
        DropButton.Text = tostring(Default)
        DropButton.TextColor3 = Colorscheme
        DropButton.TextSize = 14
        DropButton.Parent = DropdownFrame

        Drop.BackgroundColor3 = fromRGB(17, 17, 17)
        Drop.BorderColor3 = fromRGB(40, 40, 40)
        Drop.Position = UDim2_new(0, 1, 0, 37)
        Drop.Size = UDim2_fromOffset(200, 0)
        Drop.ZIndex = 2
        Drop.ScrollBarImageColor3 = Colorscheme
        Drop.ScrollBarThickness = 2
        Drop.Visible = false
        Drop.Parent = DropdownFrame

        local Ret = {Type = 'Dropdown', Selected = Default, Exclude = excludeConfig}
        local InstancedButtons = {}
        local DropToggle = false

        local function UpdateDropdown(List)
            for i,v in pairs(InstancedButtons) do v:Destroy() end
            InstancedButtons = {}

            local x = 0
            local LastSelected = nil

            for i,v in pairs(List) do
                local Button = Instance_new('TextButton')
                local Title = Instance_new('TextLabel')

                Button.BackgroundColor3 = fromRGB(20, 20, 20)
                Button.BorderColor3 = fromRGB(30, 30, 30)
                Button.Position = UDim2_fromOffset(0, x*20)
                Button.Size = UDim2_fromOffset(200, 20)
                Button.Text = ''
                Button.ZIndex = 2
                Button.Parent = Drop

                Title.BackgroundTransparency = 1
                Title.Position = UDim2_fromOffset(10, 0)
                Title.Size = UDim2_fromOffset(190, 20)
                Title.Font = Enum.Font.SourceSansSemibold
                Title.Text = tostring(v)
                Title.TextColor3 = fromRGB(175, 175, 175)
                Title.TextSize = 14
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 2
                Title.Parent = Button

                Button.MouseButton1Click:Connect(function()
                    task.spawn(Callback, v)
                    DropButton.Text = tostring(v)
                    LastSelected = Button
                    Ret.Selected = v
                    if LastSelected then
                        TweenService:Create(LastSelected:FindFirstChild('TextLabel'), TweenInfo.new(0.2), {
                            TextColor3 = fromRGB(175, 175, 175)
                        }):Play()
                    end
                    TweenService:Create(Title, TweenInfo.new(0.2), {
                        TextColor3 = ColorschemeS
                    }):Play()
                    DropToggle = not DropToggle
                    Drop:TweenSize(UDim2_fromOffset(200, DropToggle and 200 or 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
                    task.wait(0.4);
                    Drop.Visible = DropToggle
                end)

                Button.MouseEnter:Connect(function()
                    if LastSelected ~= Button then
                        TweenService:Create(Title, TweenInfo.new(0.2), {
                            TextColor3 = fromRGB(225, 225, 225)
                        }):Play()
                    end
                end)
                Button.MouseLeave:Connect(function()
                    if LastSelected ~= Button then
                        TweenService:Create(Title, TweenInfo.new(0.2), {
                            TextColor3 = fromRGB(175, 175, 175)
                        }):Play()
                    end
                end)

                x = x + 1

                table.insert(InstancedButtons, Button)
            end

            if DropToggle then
                Drop.Size = UDim2_fromOffset(200, math.min(x*20, 200))
            end
            Drop.CanvasSize = UDim2_fromOffset(0, x*20)
        end

        DropdownFrame.MouseEnter:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(225, 225, 225)
            }):Play()
        end)

        DropdownFrame.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(200, 200, 200)
            }):Play()
        end)

        DropButton.MouseButton1Click:Connect(function()
            DropToggle = not DropToggle
            Drop:TweenSize(UDim2_fromOffset(200, DropToggle and math.min(#InstancedButtons*20, 200) or 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
            task.wait(DropToggle and 0 or 0.1)
            Drop.Visible = DropToggle
        end)

        UpdateDropdown(List)

        function Ret:UpdateList(newList) UpdateDropdown(newList) end
        function Ret:UpdateTitle(newTitle) Title.Text = newTitle end
        function Ret:UpdateSelected(newSelected)
            DropButton.Text = tostring(newSelected)
            task.spawn(Callback, newSelected)
        end

        SectionTable[Name] = Ret

        SectionalY = SectionalY + 40
        Section.Size = Section.Size + UDim2_fromOffset(0, 40)

        return Ret
    end
    function Ret:Slider(Name, Min, Max, Def, Callback, noFill, FloorCallback)
        local SliderFrame = Instance_new('Frame')
        local Title = Instance_new('TextLabel')
        local SliderBounds = Instance_new('Frame')
        local Slider = Instance_new('Frame')

        SliderFrame.BackgroundColor3 = fromRGB(17, 17, 17)
        SliderFrame.BorderColor3 = fromRGB(17, 17, 17)
        SliderFrame.Position = UDim2_fromOffset(13, SectionalY)
        SliderFrame.Size = UDim2_fromOffset(200, 30)
        SliderFrame.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(200, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.TextColor3 = Colorscheme
        Title.RichText = true
        Title.Text = string.format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, Def)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = SliderFrame

        SliderBounds.BackgroundColor3 = fromRGB(25, 25, 25)
        SliderBounds.BorderColor3 = fromRGB(40, 40, 40)
        SliderBounds.Position = UDim2_fromOffset(0, 20)
        SliderBounds.Size = UDim2_fromOffset(200, 10)
        SliderBounds.Parent = SliderFrame

        Slider.BackgroundColor3 = Colorscheme
        Slider.BorderColor3 = fromRGB(40, 40, 40)
        Slider.Position = UDim2_fromOffset(0, 20)
        Slider.Size = UDim2_fromOffset(200, 10)
        Slider.Parent = SliderFrame

        local Ret = {Type = 'Slider', SlideValue = Def}
        local Range = Max - Min
        local clamp = math.clamp
        local format = string.format
        local floor = math.floor
        local SlideValue = Def

        local thing = (Def - Min) / Range * SliderBounds.AbsoluteSize.X
        Slider.Size = UDim2_fromOffset(noFill and 2 or thing, 10)
        Slider.Position = UDim2_fromOffset(noFill and thing or 0, 20)

        SliderBounds.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local Position = SliderBounds.AbsolutePosition.X
                local Size = SliderBounds.AbsoluteSize.X

                local Ratio = (Mouse.X - Position) / Size
                local Value = (Ratio * Range) + Min; Ret.SlideValue = Value
                Title.Text = format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, floor(Value))

                task.spawn(Callback, FloorCallback and floor(Value) or Value)
                Slider:TweenSizeAndPosition(
                    UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                    UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quint,
                    0.1,
                    true
                )

                local MouseMove = Mouse.Move:Connect(function()
                    local Ratio = clamp((Mouse.X - Position) / Size, 0, 1)
                    local Value = (Ratio * Range) + Min; SlideValue = Value

                    task.spawn(Callback, FloorCallback and floor(Value) or Value)

                    Title.Text = format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, floor(Value))
                    Slider:TweenSizeAndPosition(
                        UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                        UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quint,
                        0.1,
                        true
                    )
                end)
                local EndedCon = nil
                EndedCon = SliderBounds.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        EndedCon:Disconnect()
                    end
                end)
            end
        end)

        function Ret:UpdateValue(newValue)
            assert(clamp(newValue, Min, Max) == newValue, 'Value is not in range')

            task.spawn(Callback, newValue)

            local Size = SliderBounds.AbsoluteSize.X
            local Ratio = (newValue - Min) / Range
            Ret.SlideValue = newValue
            Title.Text = format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, newValue)

            Slider:TweenSizeAndPosition(
                UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quint,
                0.1,
                true
            )
        end
        function Ret:UpdateMin(newMin)
            assert(newMin < Max, 'Min is greater than max')

            Min = newMin
            Range = Max - Min
            local Size = SliderBounds.AbsoluteSize.X
            local Ratio = (Ret.SlideValue - Min) / Range

            Slider:TweenSizeAndPosition(
                UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quint,
                0.1,
                true
            )
        end
        function Ret:UpdateMax(newMax)
            assert(newMax > Min, 'Max is less than min')

            Max = newMax
            Range = Max - Min
            local Size = SliderBounds.AbsoluteSize.X
            local Ratio = (Ret.SlideValue - Min) / Range

            Slider:TweenSizeAndPosition(
                UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quint,
                0.1,
                true
            )
        end
        function Ret:UpdateTitle(newTitle)
            Title.Text = format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', newTitle, SlideValue)
        end

        SectionTable[Name] = Ret

        SectionalY = SectionalY + 35
        Section.Size = Section.Size + UDim2_fromOffset(0, 35)

        return Ret
    end
    function Ret:Colorpicker(Name, Def, Callback)
        return newColorPicker(false, Section, Name, Def, Callback);
    end
    function Ret:Keybind(Name, DefaultKey, setCallback, onInput)
        return newKeybind(false, Section, Name, DefaultKey, setCallback, onInput);
    end
    function Ret:UserInput(Name, Default, Callback)
        local Main = Instance_new('Frame')
        local Title = Instance_new('TextLabel')
        local InputBox = Instance_new('TextBox')

        Main.BackgroundColor3 = fromRGB(17, 17, 17)
        Main.BorderColor3 = fromRGB(17, 17, 17)
        Main.Position = UDim2_fromOffset(13, SectionalY)
        Main.Size = UDim2_fromOffset(200, 20)
        Main.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(75, 20)
        Title.Font = Enum.Font.SourceSans
        Title.TextColor3 = fromRGB(200, 200, 200)
        Title.Text = Name
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Main

        InputBox.BackgroundColor3 = fromRGB(17, 17, 17)
        InputBox.BorderColor3 = fromRGB(40, 40, 40)
        InputBox.Position = UDim2_fromOffset(85, 3)
        InputBox.Size = UDim2_fromOffset(115, 15)
        InputBox.ClearTextOnFocus = false
        InputBox.Font = Enum.Font.SourceSans
        InputBox.Text = Default
        InputBox.TextColor3 = Colorscheme
        InputBox.TextScaled = true
        InputBox.Parent = Main

        local Ret = {Type = 'UserInput', CurrentInput = Default}

        InputBox:GetPropertyChangedSignal('Text'):Connect(function()
            Ret.CurrentInput = InputBox.Text
            task.spawn(Callback, InputBox.Text)
        end)

        function Ret:UpdateTitle(newTitle) Title.Text = newTitle end
        function Ret:UpdateInput(newInput)
            InputBox.Text = newInput;
            Ret.CurrentInput = newInput
            task.spawn(Callback, newInput)
        end

        SectionTable[Name] = Ret

        SectionalY = SectionalY + 23
        Section.Size = Section.Size + UDim2_fromOffset(0, 20)
    end
    function Ret:Button(Name, Callback)
        local Button = Instance_new('TextButton')

        Button.BackgroundColor3 = fromRGB(17, 17, 17)
        Button.BorderColor3 = fromRGB(40, 40, 40)
        Button.AutoButtonColor = false
        Button.Position = UDim2_fromOffset(13, SectionalY + 2)
        Button.Size = UDim2_fromOffset(200, 15)
        Button.Font = Enum.Font.SourceSansSemibold
        Button.Text = '  ' .. Name
        Button.TextColor3 = fromRGB(200, 200, 200)
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Center
        Button.Parent = Section

        local Ret = {}

        Button.MouseButton1Click:Connect(function()
            task.spawn(Callback, );
            Button.TextColor3 = Colorscheme
            Button.BackgroundColor3 = fromRGB(15, 15, 15);
            TweenService:Create(Button, TweenInfo.new(.7), {
                BackgroundColor3 = fromRGB(17, 17, 17),
                TextColor3 = fromRGB(200, 200, 200)
            }):Play();
        end);


        function Ret:UpdateTitle(newTitle) Button.Text = newTitle end

        SectionalY = SectionalY + 20
        Section.Size = Section.Size + UDim2_fromOffset(0, 20)

        return Ret
    end

    return Ret
end

local function Section(Tab, TabTable)
    local Ret = {}
    local R, L = {}, {}
    local RLToggle = false

    local function UpdatePositions(RL, Section)
        local LastY = Section and Section.Position.Y.Offset + Section.AbsoluteSize.Y + SectionSpace or 15
        local Sectional = RL == 'R' and R or L
        local SX = RL == 'R' and 250 or 10
        for i=(Section and table.find(Sectional, Section)+1 or 1), #Sectional do
            local CurrentSection = Sectional[i]
            CurrentSection.Position = UDim2_fromOffset(SX, LastY)
            LastY = LastY + CurrentSection.AbsoluteSize.Y + SectionSpace
        end
    end

    local function UpdateTabScroll()
        local Ry, Ly = 15, 15
        for i,v in pairs(R) do Ry = Ry + v.AbsoluteSize.Y + SectionSpace end
        for i,v in pairs(L) do Ly = Ly + v.AbsoluteSize.Y + SectionSpace end

        Tab.CanvasSize = UDim2_fromOffset(0, math.max(Ry, Ly) + 15)
    end

    function Ret:Section(Name)
        local Section = Instance_new('Frame')
        local BorderHide = Instance_new('Frame')
        local Title = Instance_new('TextLabel')

        Section.BackgroundColor3 = fromRGB(17, 17, 17)
        Section.BorderColor3 = fromRGB(40, 40, 40)
        Section.Position = UDim2_fromOffset(RLToggle and 250 or 10, 15)
        Section.Size = UDim2_fromOffset(220, 20)
        Section.Parent = Tab

        Title.BackgroundTransparency = 1
        Title.Position = UDim2_fromOffset(15, -10)
        Title.Size = UDim2_fromOffset(185, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = Name
        Title.TextColor3 = Colorscheme
        Title.TextSize = 15
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = Section

        BorderHide.BackgroundColor3 = fromRGB(17, 17, 17)
        BorderHide.BorderColor3 = fromRGB(17, 17, 17)
        BorderHide.Position = UDim2_fromOffset(10, 0)
        BorderHide.Size = UDim2_fromOffset(Title.TextBounds.X + 10, 1)
        BorderHide.Parent = Section

        local SectionTable = {}
        local SectionControl = {}
        TabTable[Name] = SectionTable

        local Sectional = RLToggle and 'R' or 'L'

        Section:GetPropertyChangedSignal('Size'):Connect(function()
            UpdatePositions(Sectional, Section)
            UpdateTabScroll()
        end)

        function SectionControl:SetLeft()
            local CurrentSec = Sectional == 'R' and R or L
            table.remove(CurrentSec, table.find(CurrentSec, Section))
            table.insert(L, Section)
            Sectional = 'L'
            UpdatePositions('R'); UpdatePositions('L')
        end

        function SectionControl:SetRight()
            local CurrentSec = Sectional == 'R' and R or L
            table.remove(CurrentSec, table.find(CurrentSec, Section))
            table.insert(R, Section)
            Sectional = 'R'
            UpdatePositions('R'); UpdatePositions('L')
        end

        table.insert(RLToggle and R or L, Section); UpdatePositions(Sectional)
        RLToggle = not RLToggle

        return UiElements(Section, SectionTable, SectionControl)
    end

    return Ret
end

local function Tab(Window, Name, TabTable)
    local TabFrame = Instance_new('ScrollingFrame')
    local TabButton = Instance_new('TextButton')
    local BorderHide = Instance_new('Frame')

    TabFrame.BackgroundColor3 = fromRGB(20, 20, 20)
    TabFrame.BorderColor3 = fromRGB(40, 40, 40)
    TabFrame.Position = UDim2_fromOffset(10, 55)
    TabFrame.Size = UDim2_fromOffset(480, 385)
    TabFrame.Visible = false
    TabFrame.ScrollBarThickness = 2
    TabFrame.ScrollBarImageColor3 = Colorscheme
    TabFrame.Parent = Window

    TabButton.AutoButtonColor = false
    TabButton.BackgroundColor3 = fromRGB(22, 22, 22)
    TabButton.BorderColor3 = fromRGB(22, 22, 22)
    TabButton.Position = UDim2_fromOffset(11 + 71 * #Tabs, 33)
    TabButton.Size = UDim2_fromOffset(70, 20)
    TabButton.Font = Enum.Font.SourceSansSemibold
    TabButton.TextColor3 = fromRGB(225, 225, 225)
    TabButton.Text = Name
    TabButton.TextSize = 14
    TabButton.Parent = Window

    BorderHide.BackgroundColor3 = fromRGB(20, 20, 20)
    BorderHide.BorderSizePixel = 0
    BorderHide.Position = UDim2_fromOffset(-1, 21)
    BorderHide.Size = UDim2_fromOffset(70, 1)
    BorderHide.Visible = false
    BorderHide.Parent = TabButton

    if #Tabs < 1 then
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = fromRGB(20, 20, 20)
        TabButton.BorderColor3 = fromRGB(20, 20, 20)
        TabButton.TextColor3 = Colorscheme
        BorderHide.Visible = true
    end

    TabButton.MouseButton1Click:Connect(function()
        for i,v in pairs(Tabs) do
            local B = v.Button
            v.Tab.Visible = false
            B.BackgroundColor3 = fromRGB(22, 22, 22)
            B.BorderColor3 = fromRGB(22, 22, 22)
            B.TextColor3 = fromRGB(225, 225, 225)
            v.BorderHide.Visible = false
        end

        TabFrame.Visible = true
        TabButton.BackgroundColor3 = fromRGB(20, 20, 20)
        TabButton.BorderColor3 = fromRGB(20, 20, 20)
        TabButton.TextColor3 = Colorscheme
        BorderHide.Visible = true
    end)

    table.insert(Tabs, {
        Tab = TabFrame,
        Button = TabButton,
        BorderHide = BorderHide
    })

    return Section(TabFrame, TabTable)
end

function UiLib:CreateWindow(Name, Game, ColorScheme)
    Colorscheme = ColorScheme

    local ScreenGui = Instance_new('ScreenGui')
    local MainFrame = Instance_new('Frame')
    local Title = Instance_new('TextLabel')
    local StatusFrame = Instance_new('Frame')
    local GameName = Instance_new('TextLabel')
    local ElapsedTime = Instance_new('TextLabel')
    local CurrentTime = Instance_new('TextLabel')
    local Divider, Divider2 = Instance_new('Frame'), Instance_new('Frame')

    local Viewport = game.Workspace.Camera.ViewportSize;
    local CenterCoords = Vector2.new(math.floor(Viewport.X/2), math.floor(Viewport.Y/2));

    getgenv().fah = ScreenGui
    ScreenGui.Parent = game.CoreGui

    MainFrame.BackgroundColor3 = fromRGB(25, 25, 25)
    MainFrame.BorderColor3 = fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2_new(0, CenterCoords.X - 500 / 2, 0, CenterCoords.Y - 450 / 2)
    MainFrame.Size = UDim2_fromOffset(0, 25) -- UDim2_fromOffset(500, 450)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Title.BackgroundTransparency = 1
    Title.Position = UDim2_fromOffset(7, 2)
    Title.Size = UDim2_fromOffset(100, 26)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = Name
    Title.RichText = true
    Title.TextColor3 = fromRGB(220, 220, 220)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    StatusFrame.BackgroundColor3 = fromRGB(25, 25, 25)
    StatusFrame.BorderColor3 = fromRGB(25, 25, 25)
    StatusFrame.Parent = MainFrame

    GameName.BackgroundTransparency = 1
    GameName.Size = UDim2_fromOffset(200, 15)
    GameName.Font = Enum.Font.SourceSansSemibold
    GameName.Text = Game
    GameName.TextColor3 = fromRGB(255, 255, 255)
    GameName.TextSize = 15
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.Parent = StatusFrame

    Divider.BackgroundColor3 = fromRGB(45, 45, 45)
    Divider.Position = UDim2_fromOffset(GameName.TextBounds.X + 10, 0)
    Divider.Size = UDim2_fromOffset(0, 2, 0, 17)
    Divider.Parent = StatusFrame

    ElapsedTime.BackgroundTransparency = 1
    ElapsedTime.Position = UDim2_fromOffset(Divider.Position.X.Offset + 10, 0)
    ElapsedTime.Size = UDim2_fromOffset(55, 15)
    ElapsedTime.Font = Enum.Font.SourceSansSemibold
    ElapsedTime.Text = '00:00:00'
    ElapsedTime.TextColor3 = fromRGB(200, 200, 200)
    ElapsedTime.TextSize = 15
    ElapsedTime.TextXAlignment = Enum.TextXAlignment.Left
    ElapsedTime.Parent = StatusFrame

    Divider2.BackgroundColor3 = fromRGB(45, 45, 45)
    Divider2.Position = UDim2_fromOffset(ElapsedTime.Position.X.Offset + ElapsedTime.TextBounds.X + 10, 0)
    Divider2.Size = UDim2_fromOffset(2, 17)
    Divider2.Parent = StatusFrame

    CurrentTime.BackgroundTransparency = 1
    CurrentTime.Position = UDim2_fromOffset(Divider2.Position.X.Offset + 10, 0)
    CurrentTime.Size = UDim2_fromOffset(55, 15)
    CurrentTime.Font = Enum.Font.SourceSansSemibold
    CurrentTime.Text = os.date('%X')
    CurrentTime.TextColor3 = fromRGB(200, 200, 200)
    CurrentTime.TextSize = 15
    CurrentTime.TextXAlignment = Enum.TextXAlignment.Left
    CurrentTime.Parent = StatusFrame

    local WindowReturn = {
        VisiblityKey = Enum.KeyCode.BackSlash,
        Tabs = {}
    }
    local StatusLength = CurrentTime.Position.X.Offset + CurrentTime.AbsoluteSize.X
    local VisiblityToggle = true
    --local LoadTime = os.time()

    StatusFrame.Size = UDim2_fromOffset(StatusLength, 15)
    StatusFrame.Position = UDim2_fromOffset(500 - StatusLength, 7)

    --[[task.spawn(function()
        while task.wait(1) do
            ElapsedTime.Text = os.time() - LoadTime

        end
    end)]]

    task.spawn(function()
        MainFrame:TweenSize(UDim2_fromOffset(500, 25), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
        task.wait(0.2)
        MainFrame:TweenSize(UDim2_fromOffset(500, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == WindowReturn.VisiblityKey and not gp then
            VisiblityToggle = not VisiblityToggle

            MainFrame.Visible = VisiblityToggle
        end
    end)

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for i,v in pairs(game.CoreGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)) do
                if v:IsDescendantOf(MainFrame) and v ~= MainFrame then return end
            end

            local Dist = Vector2.new(Mouse.X, Mouse.Y) - MainFrame.AbsolutePosition

            local MouseMove = Mouse.Move:Connect(function()
                MainFrame.Position = UDim2_fromOffset(Mouse.X - Dist.X, Mouse.Y - Dist.Y)
            end)
            local EndedCon = nil
            EndedCon = MainFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    MouseMove:Disconnect()
                    EndedCon:Disconnect()
                end
            end)
        end
    end)

    function WindowReturn:Tab(Name)
        WindowReturn.Tabs[Name] = {}
        return Tab(MainFrame, Name, WindowReturn.Tabs[Name])
    end

    function WindowReturn:GenerateConfig()
        return HttpService:JSONEncode(WindowReturn.Tabs)
    end

    function WindowReturn:LoadConfig(ConfigJSON)
        local Config = HttpService:JSONDecode(ConfigJSON)

        for i,v in pairs(WindowReturn.Tabs) do
            local Tab = Config[i]
            for x,d in pairs(v) do
                local Section = Tab[x]
                for i,v in pairs(d) do
                    local Element = Section[i]
                    if (not Element) then continue; end
                    if v.Type == 'Toggle' then v:UpdateToggle(Element.Toggle)
                    elseif v.Type == 'Dropdown' and not v.Exclude then v:UpdateSelected(Element.Selected)
                    elseif v.Type == 'Slider' then v:UpdateValue(Element.SlideValue)
                    elseif v.Type == 'Colorpicker' then local ColorTable = Element.ColorTable; v:UpdateColor(Color3.new(ColorTable.R, ColorTable.G, ColorTable.B))
                    elseif v.Type == 'Keybind' and Element.KeyStr ~= 'nil' then local KeySplit = string.split(Element.KeyStr, '.'); v:UpdateBind(Enum[KeySplit[2]][KeySplit[3]])
                    elseif v.Type == 'UserInput' then v:UpdateInput(Element.CurrentInput)
                    end
                end
            end
        end
    end

    function WindowReturn:SetKeybindClose(Keycode)
        WindowReturn.VisiblityKey = Keycode;
    end

    return WindowReturn
end

return UiLib
