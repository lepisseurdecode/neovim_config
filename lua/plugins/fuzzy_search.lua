return {
	{
	'nvim-telescope/telescope-frecency.nvim',
		dependency = 'nvim-telescope/telescope.nvim',
		config = function () require('telescope').load_extension('frecency') end
	},
	{
		'LukasPietzschmann/telescope-tabs',
		dependency = 'nvim-telescope/telescope.nvim',
		config = function ()
			local tabs = require("telescope-tabs")
			tabs.setup()
			vim.api.nvim_set_keymap('n', '<leader>ftt', '', {noremap = true, callback = tabs.list_tabs})
		end
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		dependency = 'nvim-telescope/telescope.nvim',
		config = function () require('telescope').load_extension('fzf') end
	},
	{
		'nvim-telescope/telescope.nvim',
		dependency = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'nvim-telescope/telescope-fzf-native.nvim',
			'nvim-telescope/telescope-frecency.nvim',
		},
		config = function ()
			local set_actions = require('telescope.actions.set')
			local telescope = require('telescope')
			telescope.setup{
				defaults = {
					file_ignore_patterns = {".git\\", '.git/', '.cache', '%.user', 'build*', 'node_modules'},
					mappings = {
						i = {
							["<cr>"] = function(bufnr)
								set_actions.edit(bufnr, 'tab drop')
							end,
							["<c-s>"] = function(bufnr)
								set_actions.edit(bufnr, 'vsplit')
							end,
						}
					}
				}
			}
			local builtin = require'telescope.builtin'
			vim.api.nvim_set_keymap('n', '<leader>ff', '', {noremap = true, callback = builtin.find_files})
			vim.api.nvim_set_keymap('n', '<leader>fg', '', {noremap = true, callback = builtin.live_grep})
			vim.api.nvim_set_keymap('n', '<leader>fb', '', {noremap = true, callback = builtin.buffers})
			vim.api.nvim_set_keymap('n', '<leader>fh', '', {noremap = true, callback = builtin.help_tags})
			vim.api.nvim_set_keymap('n', '<leader>fr', '', {noremap = true, callback = builtin.lsp_references})
			vim.api.nvim_set_keymap('n', '<leader>fe', '', {noremap = true, callback = builtin.diagnostics})
			vim.api.nvim_set_keymap('n', '<leader>fi', '', {noremap = true, callback = builtin.lsp_implementations})
			vim.api.nvim_set_keymap('n', '<leader>fd', '', {noremap = true, callback = builtin.lsp_definitions})
			vim.api.nvim_set_keymap('n', '<leader>ftr', '', {noremap = true, callback = builtin.lsp_references})
			vim.api.nvim_set_keymap('n', '<leader>fti', '', {noremap = true, callback = builtin.lsp_implementations})
			vim.api.nvim_set_keymap('n', '<leader>ftd', '', {noremap = true, callback = builtin.lsp_definitions})

		end
	}

}
