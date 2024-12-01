return {
	{
		'nanozuki/tabby.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			local tabby = require 'tabby'
			tabby.setup {}
			vim.keymap.set('n', 'ú', '<cmd>Tabby jump_to_tab<CR>')
		end,
	},
}
