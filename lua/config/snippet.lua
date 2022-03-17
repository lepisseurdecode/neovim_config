local snippet = {}
local snip = require('luasnip')

_G.expand_or_jump_ifn = function()
		if snip.expand_or_jumpable() then
			snip.expand_or_jump()
		end
		return ''
	end

_G.jump_back_ifn = function() 
		if snip.jumpable(-1) then
			snip.jump(-1)
		end
		return ''
	end

function snippet.config()
	vim.api.nvim_set_keymap('i', '<c-l>', 'v:lua.expand_or_jump_ifn()', {expr= true})
	vim.api.nvim_set_keymap('s', '<c-l>', 'v:lua.expand_or_jump_ifn()', {expr= true})
	vim.api.nvim_set_keymap('i', '<c-h>', 'v:lua.jump_back_ifn()', {expr = true})
	vim.api.nvim_set_keymap('s', '<c-h>', 'v:lua.jump_back_ifn()', {expr = true})
end

return snippet
