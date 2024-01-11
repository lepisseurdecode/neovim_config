
return {
	'L3MON4D3/LuaSnip',
	config = function()
		local snip = require('luasnip')
		vim.keymap.set({'i','s'}, '<C-l>', function()
			local snip = require('luasnip')
			if snip.expand_or_jumpable() then
				snip.expand_or_jump()
			end
		end,
		{}
		)
		vim.keymap.set({'i','s'}, '<C-h>', function() 
			if snip.jumpable(-1) then
				snip.jump(-1)
			end
		end,
		{}
		)
		vim.keymap.set({'i','s'}, '<C-j>', function()
			if snip.choice_active() then 
				snip.change_choice(1)
			end
			return ''
		end,
		{}
		)

		vim.keymap.set({'i','s'}, '<C-k>', function()
			if snip.choice_active() then 
				snip.change_choice(-1)
			end
			return ''
		end,
		{}
		)
		require("luasnip.loaders.from_lua").load( { paths = "./lua/snippets" } )
	end
}
