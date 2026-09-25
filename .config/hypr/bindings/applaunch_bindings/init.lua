local globals = require("globals")

local function launch_tui(cmd)
	return hl.dsp.exec_cmd(globals.terminal .. " -e " .. cmd)
end

hl.bind("SUPER + W", hl.dsp.window.close(), { description = "close window" })
hl.bind("SUPER + CTRL + W", hl.dsp.window.kill(), { description = "kill window" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(globals.app_launcher), { description = "open app launcher" })
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(globals.terminal), { description = "open terminal" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(globals.browser), { description = "open browser" })
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd(globals.incog_browser), { description = "open incognito browser" })
hl.bind("SUPER + S", hl.dsp.exec_cmd("spotify-launcher"), { description = "open spotify launcher" })
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd(
		globals.sound_control,
		{ float = true, no_anim = true, size = { "(monitor_w*0.5)", "(monitor_h*0.5)" } }
	),
	{ description = "open sound control" }
)
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd(globals.lock_screen), { description = "lock screen" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(globals.file_browser), { description = "open file browser" })
hl.bind("SUPER + ALT + B", launch_tui("btop"), { description = "launch btop" })
hl.bind("SUPER + ALT + F", launch_tui("yazi"), { description = "launch yazi" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"), { description = "copy color to clipboard" })

hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd("qs ipc call launcher openClipboard"), { description = "open clipboard" })
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("qs ipc call launcher openKeybinds"), { description = "open keybind search" })
