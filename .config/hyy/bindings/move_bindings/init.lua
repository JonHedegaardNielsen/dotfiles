hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }), { mouse = true })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }), { mouse = true })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }), { mouse = true })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }), { mouse = true })

hl.bind("SUPER + ALT + L", hl.dsp.workspace.move({ monitor = 1 }))
hl.bind("SUPER + ALT + H", hl.dsp.workspace.move({ monitor = 0 }))

for i = 1, 9 do
	hl.bind("SUPER + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
	hl.bind("SUPER + SHIFT + ALT + " .. tostring(i), hl.dsp.window.move({ workspace = i, follow = false }))
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
end
