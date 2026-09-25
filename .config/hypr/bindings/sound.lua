hl.bind(
	"SUPER + SHIFT + CTRL + M",
	hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
	{ description = "toggle sink mute" }
)
hl.bind(
	"SUPER + SHIFT + CTRL + U",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
	{ description = "raise volume" }
)
hl.bind(
	"SUPER + SHIFT + CTRL + D",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
	{ description = "lower volume" }
)
