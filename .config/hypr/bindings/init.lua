hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "reload hyprland config" })

require("bindings.focus_bindings")
require("bindings.move_bindings")
require("bindings.sound")

-- require("bindings.noctalia")
require("bindings.sizing_bindings")
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("pkill waybar || waybar"), { description = "toggle status bar" })
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("pkill qs || qs"), { description = "restart quickshell" })
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { description = "toggle window floating" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen(), { description = "toggle fullscreen" })
hl.bind("SUPER + Z", hl.dsp.layout("togglesplit"), { description = "toggle split layout" })

hl.bind("SUPER + SHIFT + DELETE", hl.dsp.exit(), { description = "exit hyprland" })
require("bindings.applaunch_bindings")
require("bindings.spotify")
require("bindings.screenshot")
require("bindings.notifications")
