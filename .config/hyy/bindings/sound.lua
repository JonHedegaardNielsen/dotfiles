hl.bind("SUPER + SHIFT + CTRL + M", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("SUPER + SHIFT + CTRL + U", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("SUPER + SHIFT + CTRL + D", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
