hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "drag window with mouse" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "resize window with mouse" })

hl.bind(
	"SUPER + SHIFT + H",
	hl.dsp.window.move({ direction = "left" }),
	{ mouse = true, description = "move window left" }
)
hl.bind(
	"SUPER + SHIFT + L",
	hl.dsp.window.move({ direction = "right" }),
	{ mouse = true, description = "move window right" }
)
hl.bind(
	"SUPER + SHIFT + J",
	hl.dsp.window.move({ direction = "down" }),
	{ mouse = true, description = "move window down" }
)
hl.bind(
	"SUPER + SHIFT + K",
	hl.dsp.window.move({ direction = "up" }),
	{ mouse = true, description = "move window up" }
)

hl.bind("SUPER + ALT + L", hl.dsp.workspace.move({ monitor = 1 }), { description = "move workspace to monitor 1" })
hl.bind("SUPER + ALT + H", hl.dsp.workspace.move({ monitor = 0 }), { description = "move workspace to monitor 0" })

for i = 1, 9 do
	hl.bind(
		"SUPER + SHIFT + " .. tostring(i),
		hl.dsp.window.move({ workspace = i }),
		{ description = "move window to workspace " .. tostring(i) }
	)
	hl.bind(
		"SUPER + SHIFT + ALT + " .. tostring(i),
		hl.dsp.window.move({ workspace = i, follow = false }),
		{ description = "move window to workspace " .. tostring(i) .. " without following" }
	)
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }), { description = "focus workspace " .. tostring(i) })
end
