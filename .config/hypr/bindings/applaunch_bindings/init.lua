local globals = require("globals")

local function launch_tui(cmd)
	return hl.dsp.exec_cmd(globals.terminal .. " -e " .. cmd)
end

hl.bind("SUPER + W", hl.dsp.window.close(), { description = "close window" })
hl.bind("SUPER + CTRL + W", hl.dsp.window.kill(), { description = "kill window" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(globals.app_launcher), { description = "open app launcher" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("~/dotfiles/scripts/emoji.sh"), { description = "open emoji picker" })
hl.bind("SUPER + CTRL + SPACE", hl.dsp.window.set_prop({ prop = "opacity", value = "1" }))
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd(globals.terminal))
hl.bind("SUPER + RETURN", launch_tui("~/dotfiles/scripts/tmux_attach_or_start.sh"), { description = "open terminal" })
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
hl.bind(
	"SUPER + ALT + C",
	hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --with-nth=2 --prompt='clipboard: ' | cliphist decode | wl-copy"),
	{ description = "open clipboard" }
)
hl.bind(
	"SUPER + ALT + K",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/binds-fuzzel.sh"),
	{ description = "open keybind search" }
)

hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("~/dotfiles/scripts/open_project.sh"), { description = "open project" })
