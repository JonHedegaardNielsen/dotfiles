local globals = require("globals")
hl.curve("quick", { type = "bezier", points = { { 0.25, 1 }, { 0.10, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 1 }, { 0, 1 } } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "quick" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 20, bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "quick" })

hl.layer_rule({ match = { namespace = "rofi" }, no_anim = true })

hl.workspace_rule({ workspace = "5", layout = "scrolling" })
hl.workspace_rule({ workspace = "6", layout = "scrolling" })
