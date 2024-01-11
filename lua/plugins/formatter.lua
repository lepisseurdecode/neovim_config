return {
	'mhartington/formatter.nvim',
	dependency = 'mason.nvim',
	event = 'BufWritePre',
	config = function()
		require('formatter').setup {
			logging = true,
			log_level = vim.log.levels.Warn,
			filetype = {
				cpp = { require('formatter.filetypes.cpp').clangformat },
				lua = { require('formatter.filetypes.lua').stylua },
				-- bogue on windows
				-- ['*'] = { require('formatter.filetypes.any').remove_trailing_whitespace },
			},
		}
		local gr_name = 'formatter'
		vim.api.nvim_create_augroup(gr_name, { clear = true })
		vim.api.nvim_create_autocmd('BufWritePost', { command = 'FormatWrite', group = gr_name })
	end,
}
