return {
	{
		'nvim-treesitter/nvim-treesitter',
		config = function()
			vim.opt.foldmethod = 'expr'
			vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
			vim.opt.foldlevelstart = 99
			require('nvim-treesitter.configs').setup {
				ensure_installed = 'all',
				highlight = {
					enable = true,
					disable = {},
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = { enable = true },
				indent = { enable = true },
				fold = { enable = true },
			}
		end,
	},
	{
		'stevearc/aerial.nvim',
		key = '<F2>',
		config = function()
			require('aerial').setup {}
			vim.keymap.set('n', '<F2>', function() require('aerial').toggle { focus = true, direction = 'left' } end, {
				desc = 'aerial: Open treesitter explorer',
				noremap = true,
				silent = true,
				nowait = true,
			})
		end,
	},
}
