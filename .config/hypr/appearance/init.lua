hl.curve("quick", { type = "bezier", points = { { 0.25, 1 }, { 0.10, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 1 }, { 0, 1 } } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "quick", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = false, speed = 2, bezier = "quick", style = "popin 10%" })
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch", enabled = false })

hl.layer_rule({ match = { namespace = "qs" }, no_anim = true })
hl.layer_rule({ match = { namespace = "launcher" }, no_anim = true }) -- fuzzel
hl.layer_rule({ match = { namespace = "rofi" }, no_anim = true }) -- emoji picker

hl.workspace_rule({ workspace = "5", layout = "scrolling" })
hl.workspace_rule({ workspace = "6", layout = "scrolling" })
