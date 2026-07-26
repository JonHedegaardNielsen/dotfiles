local cmd = require("globals").noctalia_msg

hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd(cmd .. "panel-toggle control-center"))
