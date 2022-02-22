type Toggle = { UpdateToggle: (self: Toggle, toset: boolean) -> nil, UpdateTitle: (self: Toggle, name: string) -> nil }
type Dropdown = { UpdateList: (self: Dropdown, list: {}) -> nil, UpdateTitle: (self: Dropdown, name: string) -> nil }
type Colorpicker = { UpdateColor: (self: Colorpicker, NewColor: Color3) -> nil, UpdateTitle: (self: Colorpicker, name: string) -> nil }
type Keybind = { UpdateBind: (self: Keybind, NewKeybind: Enum.KeyCode) -> nil, UpdateTitle: (self: Keybind, name: string) -> nil }
type UserInput = { UpdateInput: (self: UserInput, NewInput: string) -> nil, UpdateTitle: (self: UserInput, name: string) -> nil }
type Button = { UpdateTitle: (self: Button, name: string) -> nil }
type Slider = {
    UpdateValue: (self: Slider, value: number) -> nil,
    UpdateMin: (self: Slider, min: number) -> nil,
    UpdateMax: (self: Slider, max: number) -> nil,
    UpdateTitle: (self: Slider, name: string) -> nil
}

type Main = {
    Toggle: (self: Main, name: string, default: boolean?, callback: (value: boolean) -> nil) -> Toggle,
    Dropdown: (self: Main, name: string, start: string, list: {}, callback: (selected: string) -> nil) -> Dropdown,
    Slider: (self: Main, name: string, min: number, max: number, default: number, callback: (value: number) -> nil, nofill: boolean?, floor: boolean?) -> Slider,
    Colorpicker: (self: Main, name: string, StartingColor: Color3, callback: (color: Color3) -> nil) -> Colorpicker,
    Keybind: (self: Main, name: string, StartingKey: Enum.KeyCode?, onset: (keycode: Enum.KeyCode) -> nil, oninput: () -> nil) -> Keybind,
    Button: (self: Main, name: string, callback: () -> nil) -> Button,
    UserInput: (self: Main, default: string, callback: () -> nil) -> UserInput
}

type Section = { Section: (self: Section, name: string) -> Main }
type Window = { Tab: (self: Window, name: string) -> Section, VisiblityKey: Enum.KeyCode }
type Library = { CreateWindow: (self: Library, name: string, game: string, colorscheme: Color3?) -> Window }
