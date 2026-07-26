local globals = require("globals")

local function launch_tui(cmd)
	return hl.dsp.exec_cmd(globals.terminal .. " -e " .. cmd)
end

hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + CTRL + W", hl.dsp.window.kill())
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(globals.app_launcher))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(globals.terminal))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(globals.browser))
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd(globals.incog_browser))
hl.bind("SUPER + S", hl.dsp.exec_cmd("spotify-launcher"))
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd(
		globals.sound_control,
		{ float = true, no_anim = true, size = { "(monitor_w*0.5)", "(monitor_h*0.5)" } }
	)
)
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd(globals.lock_screen))
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(globals.file_browser))
hl.bind("SUPER + ALT + B", launch_tui("btop"))
hl.bind("SUPER + ALT + F", launch_tui("yazi"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(
	"SUPER + ALT + C",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy")
)
