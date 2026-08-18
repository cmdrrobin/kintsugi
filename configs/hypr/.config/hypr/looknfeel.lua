-- Change the default Omarchy look'n'feel.

-- dim inactive windows
hl.config({
	decoration = {
		-- Use round window corners.
		rounding = 4,

		-- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
		dim_inactive = true,
		dim_strength = 0.25,
	},
})

hl.window_rule({
	name = "apply-chronium-to-workspace",
	match = {
		class = "chromium",
	},
	workspace = 1,
})

hl.window_rule({
	name = "apply-helium-to-workspace",
	match = {
		class = "helium",
	},
	workspace = 1,
})
