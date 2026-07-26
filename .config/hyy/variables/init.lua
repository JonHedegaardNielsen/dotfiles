hl.config({
	dwindle = {
		force_split = 2,
		preserve_split = true,
	},
	scrolling = {
		column_width = 1,
	},
	general = {
		border_size = 4,
		gaps_out = 0,
		gaps_in = 0,
		col = {
			active_border = 0xaa8cb8ff,
		},
	},
	input = {
		sensitivity = -0.5,
		kb_layout = "dk",
		kb_options = "caps:escape",
	},
	binds = {
		pass_mouse_when_bound = true,
	},
	decoration = {
		rounding = 5,
		active_opacity = 1,
		inactive_opacity = 0.9,
		blur = {
			enabled = true,
			size = 12,
			passes = 2,
			new_optimizations = true,
			xray = true,
		},
	},
	misc = {
		font_family = "JetBrainsMono-2.304",
		disable_autoreload = true,
		disable_splash_rendering = true,
	},
})

hl.window_rule({
	focus_on_activate = true,
})
