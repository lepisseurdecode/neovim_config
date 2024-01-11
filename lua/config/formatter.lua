local formatter = {}

function formatter.config()
	local gr_name = 'formatter'
	vim.api.nvim_create_augroup(gr_name, {clear = true})
	require('formatter').setup({
		logging = true,
		log_level = vim.log.levels.Warn,
		filetype = {
			cpp = {
				require('formatter.filetypes.cpp').clangformat
			}
		}
	})
	vim.api.nvim_create_autocmd('BufWritePost', {command = 'FormatWrite', group = gr_name})
end

return formatter
