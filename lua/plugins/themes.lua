return {
	'folke/tokyonight.nvim',
	lazy = false,
	priority = 10000,
	config = function ()
		vim.opt.termguicolors = true
		vim.cmd[[colorscheme tokyonight-night]]
		vim.cmd([[
		hi DiagnosticVirtualTextError guibg=NONE
		hi DiagnosticVirtualTextWarn guibg=NONE
		hi DiagnosticVirtualTextInfo guibg=NONE
		hi DiagnosticVirtualTextHint guibg=NONE
		]])
	end
}
