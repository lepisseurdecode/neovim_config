local lsp = {}


function map (key, cmd, prefix, postfix )
	prefix = prefix or '<cmd>lua vim.lsp.buf.'
	postfix = postfix or '()<CR>'
	vim.api.nvim_set_keymap( 'n', key, prefix .. cmd .. postfix, {noremap=true, silent=true})
end

servers = {
			'clangd',
			'pyright',
			'cmake',
			'quick_lint_js'
		}

function lsp.config()
	map('gD', 'declaration')
	map('gd', 'definition')
	map('K', 'hover')
	map('gi', 'implementation')
	map('gr', 'references')
	map('<C-k>', 'signature_help')
	map('<leader>r', 'rename')
	map('<leader>c', 'code_action')
	map('<leader>d', 'type_definition')

	for _, lsp_name in ipairs(servers) do
		require('lspconfig')[lsp_name].setup{
			on_attach = on_attach,
			flags = lsp_flags
		}
	end
end

function lsp.install()
	require('mason-lspconfig').setup{
		ensure_installed = servers,
		automatic_installation = true
	}

end
return lsp
