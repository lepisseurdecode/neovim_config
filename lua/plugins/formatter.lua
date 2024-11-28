return {
	'mhartington/formatter.nvim',
	dependencies = { 'mason.nvim' },
	event = 'BufWritePre',
	config = function()
		local util = require 'formatter.util'
		require('formatter').setup {
			logging = true,
			log_level = vim.log.levels.Warn,
			filetype = {
				cpp = { require('formatter.filetypes.cpp').clangformat },
				lua = { require('formatter.filetypes.lua').stylua },
				css = { require('formatter.filetypes.css').prettierd },
				-- flow = { require('formatter.filetypes.flow').prettierd },
				-- graphql = { require('formatter.filetypes.graphql').prettierd },
				html = { require('formatter.filetypes.html').prettierd },
				json = { require('formatter.filetypes.json').prettierd },
				-- jsx = { require('formatter.filetypes.jsx').prettierd },
				javascript = { require('formatter.filetypes.javascript').prettierd },
				-- less = { require('formatter.filetypes.less').prettierd },
				markdown = { require('formatter.filetypes.markdown').prettierd },
				scss = { require('formatter.filetypes.css').prettierd },
				typescript = { require('formatter.filetypes.typescript').prettierd },
				-- vue = { require('formatter.filetypes.vue').prettierd },
				yaml = { require('formatter.filetypes.yaml').prettierd },
				cmake = function()
					return {
						exe = 'cmake-format',
						args = {
							util.escape_path(util.get_current_buffer_file_name()),
						},
						stdin = true,
					}
				end,
				-- bogue on windows
				-- ['*'] = { require('formatter.filetypes.any').remove_trailing_whitespace },
			},
		}
		local gr_name = 'formatter'
		vim.api.nvim_create_augroup(gr_name, { clear = true })
		vim.api.nvim_create_autocmd('BufWritePost', { command = 'FormatWrite', group = gr_name })
	end,
}
