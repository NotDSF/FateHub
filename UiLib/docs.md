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
```

Dropdown:
```lua
Section:Dropdown(<string name>, <any starting value>, <table list>, <function callback>)
```

Slider:
```lua
Section:Slider(<string name>, <int min>, <int max>, <int default>, <function callback>, <bool nofill?>, <bool floor callback?>)
```

Color picker:
```lua
Section:Colorpicker(<string name>, <Color3 startingcolor?>, <function callback>)
```

Keybind:
```lua
Section:Keybind(<string name>, <Keycode startingkey?>, <function set callback>, <function input callback>)
```

Button:
```lua
Section:Button(<string name>, <function callback>)
```
