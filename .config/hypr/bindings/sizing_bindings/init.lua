local small_size_up = 30
local big_size_up = 100

hl.bind(
	"SUPER + SHIFT + ALT + PLUS",
	hl.dsp.window.resize({ x = 0, y = small_size_up, relative = true }),
	{ description = "grow window height slightly" }
)
hl.bind(
	"SUPER + SHIFT + PLUS",
	hl.dsp.window.resize({ x = 0, y = big_size_up, relative = true }),
	{ description = "grow window height" }
)
hl.bind(
	"SUPER + SHIFT + ALT + MINUS",
	hl.dsp.window.resize({ x = 0, y = -small_size_up, relative = true }),
	{ description = "shrink window height slightly" }
)
hl.bind(
	"SUPER + SHIFT + MINUS",
	hl.dsp.window.resize({ x = 0, y = -big_size_up, relative = true }),
	{ description = "shrink window height" }
)

hl.bind(
	"SUPER + ALT + PLUS",
	hl.dsp.window.resize({ x = small_size_up, y = 0, relative = true }),
	{ description = "grow window width slightly" }
)
hl.bind(
	"SUPER + PLUS",
	hl.dsp.window.resize({ x = big_size_up, y = 0, relative = true }),
	{ description = "grow window width" }
)
hl.bind(
	"SUPER + ALT + MINUS",
	hl.dsp.window.resize({ x = -small_size_up, y = 0, relative = true }),
	{ description = "shrink window width slightly" }
)
hl.bind(
	"SUPER + MINUS",
	hl.dsp.window.resize({ x = -big_size_up, y = 0, relative = true }),
	{ description = "shrink window width" }
)
