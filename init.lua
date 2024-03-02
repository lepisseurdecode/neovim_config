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

vim.filetype.add {
	extension = {
		qml = 'qmljs',
	},
}
-- Keybinding for neovim
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })
vim.api.nvim_set_keymap('n', 'ZW', '<cmd>wall<CR>', { noremap = true })
-- Configuration for the plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup 'plugins'

if nil ~= vim.loop.fs_stat(vim.fn.stdpath 'config' .. '/local_config.lua') then
	require 'local_config'
end
