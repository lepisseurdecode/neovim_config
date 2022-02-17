local chadtree = {}

function chadtree.config()
	vim.api.nvim_set_keymap('n', '<F2>', '<cmd>CHADopen<CR>', {noremap = true})
	vim.api.nvim_set_keymap('i', '<F2>', '<ESC><cmd>CHADopen<CR>', {noremap = true})
	vim.api.nvim_set_keymap('v', '<F2>', '<ESC><cmd>CHADopen<CR>', {noremap = true})
end

return chadtree
