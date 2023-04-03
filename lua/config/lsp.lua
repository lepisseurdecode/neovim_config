local lsp = {}


local function map (key, cmd, prefix, postfix )
	prefix = prefix or '<cmd>lua vim.lsp.buf.'
	postfix = postfix or '()<CR>'
	vim.api.nvim_set_keymap( 'n', key, prefix .. cmd .. postfix, {noremap=true, silent=true})
end

function Config()
	map('K', 'hover')
	map('<C-k>', 'signature_help')
	map('<leader>lr', 'rename')
	map('<leader>lc', 'code_action')
	map('gel', 'goto_next', '<cmd>lua vim.diagnostic.')
	map('geh', 'goto_prev', '<cmd>lua vim.diagnostic.')

end

function lsp.manual_config()
	require('lspconfig').qmlls.setup{
		on_attach = Config
	}
end

function Clangd_Config()
	Config()
	vim.api.nvim_set_keymap( 'n', '<leader>ls', '<cmd>ClangdSwitchSourceHeader<CR>', {noremap=true, silent=true})
end

function lsp.install()
	require('mason-lspconfig').setup{
		ensure_installed = {
			'pyright',
			'cmake',
			'quick_lint_js',
			'jsonls',
			'lua_ls',
			'clangd',
			'ltex',
			'texlab'
		},
	}

end
function lsp.mason()
	require('mason').setup({
		ensure_installed = {'clang_format'}
	})
end

function lsp.autocompletion()
	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	require('mason-lspconfig').setup_handlers{
		function (server_name)
			require('lspconfig')[server_name].setup{
				capabilities = capabilities,
				on_attach = Config
			}
		end,
		['clangd'] = function()
				require('clangd_extensions').setup{
					server = {
						capabilities = capabilities,
						on_attach = Clangd_Config,
						cmd = {'clangd','--clang-tidy'}
					},
					sorting = {
						require('clangd_extensions.cmp_scores')
					}
				}
			end
		}
end

return lsp
