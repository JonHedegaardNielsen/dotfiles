hl.bind("SUPER + N", hl.dsp.exec_cmd("qs ipc call notifications toggle"))

hl.bind("SUPER + CTRL + I", function()
	hl.notification.create({ text = "hello", timeout = 1 })
end)
