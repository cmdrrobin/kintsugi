-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Override opening terminal with Ghostty. By default Alacritty is used for Omarchy, but when I override it with Ghostty
-- including custom font-size, floating windows (e.g. cpu) will not be shown.
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Terminal", "ghostty")

hl.unbind("SUPER + CTRL + RETURN")
o.bind("SUPER + CTRL + RETURN", "Herdr", "ghostty -e herdr")

-- Set Tick Tick
-- hl.unbind("SUPER + SHIFT + T")
-- o.bind("SUPER + SHIFT + T", "Tick Tick", { omarchy = "TickTick" })
