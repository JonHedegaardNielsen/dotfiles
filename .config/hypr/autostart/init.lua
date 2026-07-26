local autoruns = {
	"wl-paste --type text --watch cliphist store",
	"wl-paste --type image --watch cliphist store",
	"hyprpaper",
	"hypridle",
	"systemctl --user start hyprpolkitagent",
}

hl.on("hyprland.start", function()
	for i, v in pairs(autoruns) do
		hl.exec_cmd(v)
	end
end)
