return {
	'nvim-tree/nvim-web-devicons',
	{
		'nvim-tree/nvim-tree.lua',
		keys = '<F3>',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			require('nvim-tree').setup {
				on_attach = function(bufnr)
					local function opts(desc)
						return {
							desc = 'nvim-tree: ' .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end
					local ok, api = pcall(require, 'nvim-tree.api')
					assert(ok, 'api module is not found')

					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set('n', '<CR>', api.node.open.tab_drop, opts 'Tab drop')
					vim.keymap.set('n', '<C-t>', function()
						local node = api.tree.get_node_under_cursor()
						local function exit_tree()
							local tree_win = api.tree.winid()
							for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
								if win ~= vim.fn.bufwinid(tree_win) then
									vim.api.nvim_set_current_win(win)
								end
							end
						end
						if 'directory' == node.type then
							local files = {}
							local path = vim.fs.normalize(node.watcher.event.path)
							for name, type in vim.fs.dir(path) do
								if 'directory' ~= type then
									files[#files + 1] = path .. '/' .. name
								end
							end
							if 0 == #files then
								return
							end
							exit_tree()
							vim.cmd('tabedit ' .. files[1])
							vim.cmd('Tabby rename_tab ' .. node.name)

							if 1 < #files then
								for i = 2, #files do
									vim.cmd('vs ' .. files[i])
								end
							end
						else
							exit_tree()
							api.node.open.tab(node)
						end
					end, opts 'Open: New Tab')
					vim.keymap.set('n', '<C-s>', api.node.open.horizontal, {
						desc = 'nvim-tree: Open Horizontal Split',
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					})
				end,
				git = { enable = false },
				renderer = {
					full_name = true,
				},
				view = {
					centralize_selection = true,
				},
				tab = {
					sync = {
						open = true,
						close = true,
					},
				},
			}

			local function tab_win_closed(winnr)
				local api = require 'nvim-tree.api'
				local tabnr = vim.api.nvim_win_get_tabpage(winnr)
				local bufnr = vim.api.nvim_win_get_buf(winnr)
				local buf_info = vim.fn.getbufinfo(bufnr)[1]
				local tab_wins = vim.tbl_filter(
					function(w) return w ~= winnr end,
					vim.api.nvim_tabpage_list_wins(tabnr)
				)
				local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
				if buf_info.name:match '.*NvimTree_%d*$' then -- close buffer was nvim tree
					-- Close all nvim tree on :q
					if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
						api.tree.close()
					end
				else -- else closed buffer was normal buffer
					if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
						local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
						if last_buf_info.name:match '.*NvimTree_%d*$' then -- and that buffer is nvim tree
							vim.schedule(function()
								if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
									vim.cmd 'quit' -- then close all of vim
								else -- else there are more tabs open
									vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
								end
							end)
						end
					end
				end
			end

			vim.api.nvim_create_autocmd('WinClosed', {
				callback = function()
					local winnr = tonumber(vim.fn.expand '<amatch>')
					vim.schedule_wrap(tab_win_closed(winnr))
				end,
				nested = true,
			})

			vim.api.nvim_set_keymap(
				'n',
				'<F3>',
				'<cmd>lua require("nvim-tree.api").tree.toggle()<CR>',
				{ noremap = true }
			)
		end,
	},
}
