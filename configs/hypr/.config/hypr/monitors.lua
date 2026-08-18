-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1.6

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- At home
hl.monitor({
	output = "desc:LG Electronics LG ULTRAFINE 408NTSU0W574",
	mode = "preferred",
	position = "auto",
	scale = omarchy_monitor_scale,
})

-- At SUE
hl.monitor({
	output = "desc:AOC CU34V5C 1UJQ1HA000261",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
