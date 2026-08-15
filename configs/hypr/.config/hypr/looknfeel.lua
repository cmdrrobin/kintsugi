-- Change the default Omarchy look'n'feel.

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
