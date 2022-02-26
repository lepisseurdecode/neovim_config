local hop = {}

function hop.config()
	require('hop').setup()
	vim.api.nvim_set_keymap( 'n', 'é', '<cmd>HopWord<CR>', {noremap=true, silent=true})
	vim.api.nvim_set_keymap( 'v', 'é', '<cmd>HopWord<CR>', {noremap=true, silent=true})
	vim.api.nvim_set_keymap( 'n', 'û', '<cmd>HopLine<CR>', {noremap=true, silent=true})
	vim.api.nvim_set_keymap( 'v', 'û', '<cmd>HopLine<CR>', {noremap=true, silent=true})
end

return hop
