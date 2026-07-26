hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

require("bindings.focus_bindings")
require("bindings.move_bindings")
require("bindings.sound")

require("bindings.noctalia")
require("bindings.sizing_bindings")
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("pkill waybar || waybar"))
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + Z", hl.dsp.layout("togglesplit"))

hl.bind("SUPER + SHIFT + DELETE", hl.dsp.exit())
require("bindings.applaunch_bindings")
require("bindings.spotify")
