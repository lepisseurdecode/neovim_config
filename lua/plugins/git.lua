return {
	'NeogitOrg/neogit',
	config = function()
		local git = require 'neogit'
		vim.api.nvim_create_user_command('G', git.open, {})
		vim.api.nvim_create_user_command('Glog', function() git.open { 'Log' } end, {})
		vim.api.nvim_create_user_command('Gcommit', function() git.open { 'Commit' } end, {})
		vim.api.nvim_create_user_command('Gdiff', function() git.open { 'Diff' } end, {})
		vim.api.nvim_create_user_command('Gfetch', function() git.open { 'Fetch' } end, {})
		vim.api.nvim_create_user_command('Gmerge', function() git.open { 'Merge' } end, {})
		vim.api.nvim_create_user_command('Gpull', function() git.open { 'Pull' } end, {})
		vim.api.nvim_create_user_command('Grebase', function() git.open { 'Rebase' } end, {})
		vim.api.nvim_create_user_command('Gstach', function() git.open { 'Stash' } end, {})
		vim.api.nvim_create_user_command('Gbranch', function() git.open { 'Branch' } end, {})
	end,
	dependencies = {
		'nvim-lua/plenary.nvim',
		'sindrets/diffview.nvim',
	},
}
