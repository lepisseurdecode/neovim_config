local snippet = {}
local snip = require('luasnip')

local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end



_G.expand_or_jump_ifn = function()
		if snip.expand_or_jumpable() then
			return t('<cmd>lua require("luasnip").expand_or_jump()<CR>')
		end
		return ''
	end

_G.jump_back_ifn = function() 
		if snip.jumpable(-1) then
			return t('<cmd>lua require("luasnip").jump(-1)<CR>')
		end
		return ''
	end

function snippet.config()
	vim.api.nvim_set_keymap('i', '<c-l>', 'v:lua.expand_or_jump_ifn()', {expr= true})
	vim.api.nvim_set_keymap('s', '<c-l>', 'v:lua.expand_or_jump_ifn()', {expr= true})
	vim.api.nvim_set_keymap('i', '<c-h>', 'v:lua.jump_back_ifn()', {expr = true})
	vim.api.nvim_set_keymap('s', '<c-h>', 'v:lua.jump_back_ifn()', {expr = true})

	snip.snippets = {
		python = {
			snip.parser.parse_snippet("cl", "class ${1}:\n	${0}"),
			snip.parser.parse_snippet("def", "def ${1}(${2}):\n	$0"),
		}
	}
end

return snippet
