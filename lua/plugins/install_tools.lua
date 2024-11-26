return {
	{
		'williamboman/mason.nvim',
		config = function() require('mason').setup() end,
	},
	{
		'williamboman/mason-lspconfig',
		dependencies = 'williamboman/mason.nvim',
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig' },
		config = function()
			-- require'mason'.setup()
			require('mason-tool-installer').setup {
				ensure_installed = {
					'clang-format',
					'stylua',
					'pyright',
					'quick_lint_js',
					'cmakelang',
					'neocmake',
					'jsonls',
					'lua_ls',
					'clangd',
					'ltex',
					'texlab',
				},
			}
		end,
	},
}
