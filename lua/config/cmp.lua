local cmp = {}

function cmp.config()
	local cmp_module = require('cmp')
	local snip = require('luasnip')
	cmp_module.setup({
		snippet = {
			expand = function(args)
				if vim.bo.filetype == 'cpp' then
					snip.lsp_expand(args.body .. '${0:;}')
				else
					snip.lsp_expand(args.body .. '${0}')

				end
			end,
		},
		mapping = {
			['<CR>'] = cmp_module.mapping.confirm{
				behavier = cmp_module.ConfirmBehavior.Insert,
				select = true 
			},
			['<C-Space>'] = cmp_module.mapping.complete(),
			['<C-j>'] = cmp_module.mapping(cmp_module.mapping.scroll_docs(-4),{'i', 'c'}),
			['<C-k>'] = cmp_module.mapping(cmp_module.mapping.scroll_docs(4),{'i', 'c'})
		},
		sources = {
			{ name = 'luasnip' },
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
					luasnip = '[snip]'
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
