Window:
```lua
UiLib:CreateWindow(<string name>, <string game>, <Color3 colorscheme>)
```
Tab:
```lua
Window:Tab(<string name>)
```

Section:
```lua
Tab:Section(<string name>)
```

\- Ui Elements -

Toggle:
```lua
Section:Toggle(<string name>, <bool default?>, <function callback>)

Toggle:UpdateToggle(<bool set>)
Toggle:UpdateTitle(<string name>
```

Dropdown:
```lua
Section:Dropdown(<string name>, <any starting value>, <table list>, <function callback>)

Dropdown:UpdateList(<table list>)
Dropdown:UpdateTitle(<string name>)
```

Slider:
```lua
Section:Slider(<string name>, <int min>, <int max>, <int default>, <function callback>, <bool nofill?>, <bool floor callback?>)

Slider:UpdateValue(<int value>)
Slider:UpdateMin(<int min>)
Slider:UpdateMax(<int max>)
Slider:UpdateTitle(<string name>)
```

Color picker:
```lua
Section:Colorpicker(<string name>, <Color3 startingcolor?>, <function callback>)

Colorpicker:UpdateColor(<Color3 newColor>)
Colorpicker:UpdateTitle(<string name>)
```

Keybind:
```lua
Section:Keybind(<string name>, <Keycode startingkey?>, <function set callback>, <function input callback>)

Keybind:UpdateBind(<KeyCode newBind>)
Keybind:UpdateTitle(<string name>)
```

Userinput:
```lua
Section:UserInput(<string name>, <string default>, <function callback>)

UserInput:UpdateInput(<string newInput>)
UserInput:UpdateTitle(<string name>)
```

Button:
```lua
Section:Button(<string name>, <function callback>)

Button:UpdateTitle(<string name>)
```
