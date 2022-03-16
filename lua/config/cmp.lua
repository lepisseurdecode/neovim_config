local cmp = {}

function cmp.config()
	local cmp_module = require('cmp')
	cmp_module.setup({
		mapping = {
			['<CR>'] = cmp_module.mapping.confirm{
				behavier = cmp_module.ConfirmBehavior.Insert,
				select = true 
			},
			['<C-Space>'] = cmp_module.mapping.complete(),
			['<C-j>'] = cmp_module.mapping(cmp_module.mapping.scroll_docs(-4),{'i', 'c'}),
			['<C-k>'] = cmp_module.mapping(cmp_module.mapping.scroll_docs(4),{'i', 'c'}),
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'path' },
			{ name = 'buffer', keyword_length = 5 },
			{ name = 'cmdline'},
		},
		formatting = {
			format = require('lspkind').cmp_format{
				with_text = true,
				menu = {
					nvim_lsp = '[LSP]',
					path = '[path]',
					buffer = '[buf]',
					cmdline = '[cmd]',
				}
			}
		}
	})

	cmp_module.setup.cmdline(':', {
		sources = {
			{name = 'cmdline'}
		}
	})

	cmp_module.setup.cmdline('/', {
		sources = {
			{name = 'buffer'}
		}
	})
end

return cmp
