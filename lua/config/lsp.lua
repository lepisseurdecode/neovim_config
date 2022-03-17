local lsp = {}

local servers = {
	'clangd',
	'pyright'
}

function map (key, cmd, prefix, postfix )
	prefix = prefix or '<cmd>lua vim.lsp.buf.'
	postfix = postfix or '()<CR>'
	vim.api.nvim_set_keymap( 'n', key, prefix .. cmd .. postfix, {noremap=true, silent=true})
end

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
end

function install()
	for _, name in pairs(servers) do 
		local server_is_found, server = require('nvim-lsp-installer').get_server(name)
		if server_is_found and not server:is_installed() then
			print('Install lsp server ' .. name)
			server:install()
		end
	end
end

function lsp.load()
	install()
	require('nvim-lsp-installer').on_server_ready(
		function(server)

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local opts = {
				capabilities = capabilities
			}

			server:setup(opts)
		end
	)
end
return lsp
