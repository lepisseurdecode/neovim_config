local function on_attach(client, bufnr)
	client.server_capabilities.semanticTokensProvider = nil
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr })
	vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr })
	vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr })
	vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { noremap = true, silent = true, buffer = bufnr })
	vim.keymap.set('n', 'gel', vim.diagnostic.goto_next, { noremap = true, silent = true, buffer = bufnr })
	vim.keymap.set('n', 'geh', vim.diagnostic.goto_prev, { noremap = true, silent = true, buffer = bufnr })
	vim.keymap.set('n', '<leader><C-s>', vim.lsp.buf.document_symbol, { noremap = true, silent = true, buffer = bufnr })
end

return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig',
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
		},
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			vim.lsp.config('qmlls', {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			require('mason-lspconfig').setup {
				function(server_name)
					vim.lsp.config(server_name, {
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
				['clangd'] = function()
					vim.lsp.config('clangd', {
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
					})
				end,
			}
		end,
	},
}
