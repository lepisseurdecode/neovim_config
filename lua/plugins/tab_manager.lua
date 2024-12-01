local function get_name(tab)
	local name = tab.name()
	local index = string.find(name, '%[')
	if nil == index then
		return name
	end

	local tree_id = require('nvim-tree.api').tree.winid { tabpage = tab.id }
	if nil == tree_id then
		return name
	end

	if tree_id == tab.current_win().id then
		return name
	end

	name = string.sub(name, 1, index - 1)
	local number = -1
	tab.wins().foreach(function(win)
		if win.id ~= tree_id then
			number = number + 1
		end
	end)

	if 0 == number then
		return name
	end

	return name .. '[' .. number .. '+]'
end

local theme = {
	fill = 'TabLineFill',
	-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
	head = 'TabLine',
	current_tab = 'TabLineSel',
	tab = 'TabLine',
	win = 'TabLine',
	tail = 'TabLine',
}

return {

	{
		'nanozuki/tabby.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			local tabby = require 'tabby'

			tabby.setup {

				line = function(line)
					return {
						{
							{ '  ', hl = theme.head },
							line.sep('', theme.head, theme.fill),
						},
						line.tabs().foreach(function(tab)
							local hl = tab.is_current() and theme.current_tab or theme.tab

							return {
								line.sep('', hl, theme.fill),
								tab.is_current() and '' or '󰆣',
								tab.number(),
								get_name(tab),
								tab.close_btn '',
								line.sep('', hl, theme.fill),
								hl = hl,
								margin = ' ',
							}
						end),
						line.spacer(),
						line.wins_in_tab(line.api.get_current_tab()).foreach(
							function(win)
								return {
									line.sep('', theme.win, theme.fill),
									win.is_current() and '' or '',
									win.buf_name(),
									line.sep('', theme.win, theme.fill),
									hl = theme.win,
									margin = ' ',
								}
							end
						),
						{
							line.sep('', theme.tail, theme.fill),
							{ '  ', hl = theme.tail },
						},
						hl = theme.fill,
					}
				end,
			}
			vim.keymap.set('n', 'ú', '<cmd>Tabby jump_to_tab<CR>')
		end,
	},
}
