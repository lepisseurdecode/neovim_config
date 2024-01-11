local function on_attach(client, bufnr)
	client.server_capabilities.semanticTokensProvider = nil
	vim.api.nvim_set_keymap(
		'n',
		'K',
		'',
		{ noremap = true, silent = true, callback = vim.lsp.buf.hover, buffer = bufnr }
	)
	vim.api.nvim_set_keymap(
		'n',
		'<C-K>',
		'',
		{ noremap = true, silent = true, callback = vim.lsp.buf.signature_help, buffer = bufnr }
	)
	vim.api.nvim_set_keymap(
		'n',
		'<leader>lr',
		'',
		{ noremap = true, silent = true, callback = vim.lsp.buf.rename, buffer = bufnr }
	)
	vim.api.nvim_set_keymap(
		'n',
		'<leader>lc',
		'',
		{ noremap = true, silent = true, callback = vim.lsp.buf.code_action, buffer = bufnr }
	)
	vim.api.nvim_set_keymap(
		'n',
		'gel',
		'',
		{ noremap = true, silent = true, callback = vim.diagnostic.goto_next, buffer = bufnr }
	)
	vim.api.nvim_set_keymap(
		'n',
		'geh',
		'',
		{ noremap = true, silent = true, callback = vim.diagnostic.goto_prev, buffer = bufnr }
	)
end

return {
	{
		'neovim/nvim-lspconfig',
		dependency = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig',
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
		},
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			require('lspconfig').qmlls.setup {
				capabilities = capabilities,
				on_attach = on_attach,
			}
			require('mason-lspconfig').setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
					}
				end,
				['clangd'] = function()
					require('lspconfig').clangd.setup {
						capabilities = capabilities,
						on_attach = function(client)
							on_attach(client)
							vim.api.nvim_set_keymap(
								'n',
								'<leader>ls',
								'<cmd>ClangdSwitchSourceHeader<CR>',
								{ noremap = true, silent = true }
							)
						end,
						cmd = { 'clangd', '--clang-tidy' },
						sorting = {
							require 'clangd_extensions.cmp_scores',
						},
					}
				end,
			}
		end,
	},
}
