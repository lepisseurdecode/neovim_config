return {
	{
		'williamboman/mason-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'neovim/nvim-lspconfig',
		},
		config = require('mason-lspconfig').setup,
	},
}
