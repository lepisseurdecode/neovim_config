local cmp = {}

function cmp.config()
	local cmp_module = require('cmp')
	local snip = require('luasnip')
	cmp_module.setup({
		snippet = {
			expand = function(args)
				snip.lsp_expand(args.body)
			end,
		},
		mapping = cmp_module.mapping.preset.insert({
			['<CR>'] = cmp_module.mapping.confirm({
				--behavier = cmp_module.ConfirmBehavior.Insert,
				select = true 
			}),
			['<C-Space>'] = cmp_module.mapping.complete(),
			['<C-j>'] = cmp_module.mapping(cmp_module.mapping.scroll_docs(-4),{'i', 'c'}),
			['<C-k>'] = cmp_module.mapping(cmp_module.mapping.scroll_docs(4),{'i', 'c'})
		}),
		sources = cmp_module.config.sources({
			{ name = 'luasnip' },
			{ name = 'nvim_lsp' },
			{ name = 'path' },
			{ name = 'buffer', keyword_length = 5 },
		}),
		formatting = {
			format = require('lspkind').cmp_format{
				with_text = true,
				menu = {
					nvim_lsp = '[LSP]',
					path = '[path]',
					buffer = '[buf]',
					cmdline = '[cmd]',
					luasnip = '[snip]'
				}
			}
		}
	})
end

return cmp
