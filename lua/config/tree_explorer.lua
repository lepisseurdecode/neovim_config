local tree_explorer = {}

function tree_explorer.config()
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	require('nvim-tree').setup({git = {enable = false}})
	vim.api.nvim_set_keymap( 'n', '<F3>','<cmd>lua require("nvim-tree.api").tree.toggle()<CR>', {noremap=true})
end

return tree_explorer
