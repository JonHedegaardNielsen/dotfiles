local next_song =
	"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"

local pause_song =
	"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause"

local un_pause_song =
	"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play"

hl.bind("SUPER + ALT + N", hl.dsp.exec_cmd(next_song), { desc = "next spotify song" })

hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd(pause_song), { desc = "pause spotify song" })
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd(un_pause_song), { desc = "start spotify song" })
