local formatter = {}

function formatter.install()
	require('mason').setup({
		ensure_installed = {'clang_format'},
		automatic_installation = true,
		automatic_setup = true
	})
end

function formatter.config()
	require('formatter').setup({
		logging = true,
		log_level = vim.log.levels.Warn,
		filetype = {
			cpp = {
				require('formatter.filetypes.cpp').clangformat
			},
			['*'] = {
				require('formatter.filetypes.any').remove_trailing_whitespace
			}
		}
	})
	vim.api.nvim_create_autocmd('BufWritePost', {command = 'FormatWrite'})
end

return formatter
