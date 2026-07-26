local small_size_up = 30
local big_size_up = 100

hl.bind("SUPER + SHIFT + ALT + PLUS", hl.dsp.window.resize({ x = 0, y = small_size_up, relative = true }))
hl.bind("SUPER + SHIFT + PLUS", hl.dsp.window.resize({ x = 0, y = big_size_up, relative = true }))
hl.bind("SUPER + SHIFT + ALT + MINUS", hl.dsp.window.resize({ x = 0, y = -small_size_up, relative = true }))
hl.bind("SUPER + SHIFT + MINUS", hl.dsp.window.resize({ x = 0, y = -big_size_up, relative = true }))

hl.bind("SUPER + ALT + PLUS", hl.dsp.window.resize({ x = small_size_up, y = 0, relative = true }))
hl.bind("SUPER + PLUS", hl.dsp.window.resize({ x = big_size_up, y = 0, relative = true }))
hl.bind("SUPER + ALT + MINUS", hl.dsp.window.resize({ x = -small_size_up, y = 0, relative = true }))
hl.bind("SUPER + MINUS", hl.dsp.window.resize({ x = -big_size_up, y = 0, relative = true }))
