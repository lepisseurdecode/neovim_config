-- Each plugin has its configuration file in ./lua/config
-- Basic options for neovim
require('config.options')

-- Keybinding for neovim
require('config.keybinding')

-- Configuration for the plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

require('config.commands')
