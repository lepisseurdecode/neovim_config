local fuzzy_search = {}

function fuzzy_search.config()
	require('telescope').setup{
		defaults = {
			file_ignore_patterns = {".git\\", '.git/', '.cache', '%.user', 'build*', 'node_modules'},
			mappings = {
				i = {
					["<cr>"] = function(bufnr)
						require('telescope.actions.set').edit(bufnr, 'tab drop')
					end,
					["<c-s>"] = function(bufnr)
						require('telescope.actions.set').edit(bufnr, 'vsplit')
					end,
				}
			}
		}
	}
	vim.api.nvim_set_keymap('n', '<leader>ff','<cmd>lua require("telescope.builtin").find_files()<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fg','<cmd>lua require("telescope.builtin").live_grep()<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fb','<cmd>lua require("telescope.builtin").buffers()<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fh','<cmd>lua require("telescope.builtin").help_tags()<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fr','<cmd>lua require("telescope.builtin").lsp_references({jump_type = "vsplit"})<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fe','<cmd>lua require("telescope.builtin").diagnostics()<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fi','<cmd>lua require("telescope.builtin").lsp_implementations({jump_type = "vsplit"})<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fd','<cmd>lua require("telescope.builtin").lsp_definitions({jump_type = "vsplit"})<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>ftr','<cmd>lua require("telescope.builtin").lsp_references({jump_type = "tab"})<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>fti','<cmd>lua require("telescope.builtin").lsp_implementations({jump_type = "tab"})<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>ftd','<cmd>lua require("telescope.builtin").lsp_definitions({jump_type = "tab"})<CR>', {noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>ftt','<cmd>lua require("telescope-tabs").list_tabs()<CR>', {noremap = true})
end

function fuzzy_search.icons()
	require('nvim-web-devicons').setup()
end

function fuzzy_search.frecency()
	require'telescope'.load_extension('frecency')
end


function fuzzy_search.opti()
	require('telescope').setup()
	require('telescope').load_extension('fzf')
end

return fuzzy_search
