-- INPUT
hl.config({
	input = {
		kb_options = "caps:escape",
		-- Natural scrolling for all input devices
		natural_scroll = true,

		touchpad = {
			-- Use natural (inverse) scrolling
			natural_scroll = true,
		},
	},
})

-- BINDING
-- Override opening terminal with Ghostty. By default Alacritty is used for Omarchy, but when I override it with Ghostty
-- including custom font-size, floating windows (e.g. cpu) will not be shown.
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Terminal", "ghostty")

-- Set Tick Tick
-- hl.unbind("SUPER + SHIFT + T")
-- o.bind("SUPER + SHIFT + T", "Tick Tick", { omarchy = "TickTick" })
