local themes = {}

function themes.config()
	vim.opt.termguicolors = true
	vim.cmd[[colorscheme tokyonight-night]]
	vim.cmd([[
		hi DiagnosticVirtualTextError guibg=NONE
		hi DiagnosticVirtualTextWarn guibg=NONE
		hi DiagnosticVirtualTextInfo guibg=NONE
		hi DiagnosticVirtualTextHint guibg=NONE
	]])
end

function themes.treesitter()
	vim.opt.foldmethod = 'expr'
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.foldlevelstart = 99
	require'nvim-treesitter.configs'.setup{
		ensure_installed = "all",
		highlight = {
			enable = true,
			disable = {},
			additional_vim_regex_highlighting = false
		},
		incremental_selection = { enable = true},
		indent = {enable = true},
		fold = {enable = true}
	}
end

function themes.statusline()
	require'lualine'.setup()
end

function themes.icons()
	require'nvim-web-devicons'.setup()
end

return themes
