local set = vim.opt

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = false
set.scrolloff = 7
set.nu = true
set.autoread = true
set.rnu = true
set.cursorline = true

vim.filetype.add({
	extension = {
		qml = 'qmljs'
	}
})
