return {
	{
		'williamboman/mason.nvim',
		config = function() require'mason'.setup() end
	},
	{
		'williamboman/mason-lspconfig',
		dependency = 'williamboman/mason.nvim',
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		dependency = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig' },
		config = function()
			-- require'mason'.setup()
			require('mason-tool-installer').setup{
				ensure_installed = {
					'clang-format',
					'stylua',
					'pyright',
					'cmake',
					'quick_lint_js',
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
