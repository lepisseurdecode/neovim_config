-- Each plugin has its configuration file in ./lua/config
-- Basic options for neovim
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

-- ~/.config/nvim/init.lua
if vim.fn.has("clipboard") == 1 then
	vim.o.clipboard = "unnamedplus" -- ✅ Utilise le register + pour le clipboard système
end

vim.filetype.add({
	extension = {
		qml = "qmljs",
	},
})

-- Keybinding for neovim
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true })
vim.api.nvim_set_keymap("n", "ZW", "<cmd>wall<CR>", { noremap = true })

-- Configuration for the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins") -- Charge les plugins depuis ~/config/nvim/lua/plugins/

vim.o.exrc = true
vim.o.secure = true
local local_config_path = vim.fn.stdpath("config") .. "/local.lua"

if vim.fn.filereadable(local_config_path) == 1 then
	dofile(local_config_path)
end
