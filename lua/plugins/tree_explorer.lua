return {
	'nvim-tree/nvim-web-devicons',
	{
		'nvim-tree/nvim-tree.lua',
		keys = '<F3>',
		depedency = 'nvim-tree/nvim-web-devicons',
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			require('nvim-tree').setup {
				on_attach = function(bufnr)
					local api = require 'nvim-tree.api'
					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set('n', '<C-s>', api.node.open.horizontal, {
						desc = 'nvim-tree: Open Horizontal Split',
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					})
				end,
				git = { enable = false },
				renderer = {
					full_name = true,
				},
				view = {
					centralize_selection = true,
				},
				tab = {
					sync = {
						open = true,
						close = true,
					},
				},
			}
			vim.api.nvim_set_keymap(
				'n',
				'<F3>',
				'<cmd>lua require("nvim-tree.api").tree.toggle()<CR>',
				{ noremap = true }
			)
		end,
	},
}
