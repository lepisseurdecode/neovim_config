return {
	'stevearc/conform.nvim',
	dependencies = { 'mason.nvim' },
	event = 'BufWritePre',
	config = function()
		local conform = require 'conform'
		conform.setup {
			format_on_save = {
				timeout_ms = 500,
				lsp_format = 'fallback',
			},
			formatters_by_ft = {
				lua = { 'stylua' },
				cpp = { 'clangformat' },
				css = { 'prettierd' },
				html = { 'prettierd' },
				json = { 'prettierd' },
				javascript = { 'prettierd' },
				markdown = { 'prettierd' },
				scss = { 'prettierd' },
				typescript = { 'prettierd' },
				yaml = { 'prettierd' },
				cmake = { 'cmakelang' },
				qmljs = { 'qmljs -i' },
			},
		}
	end,
}
