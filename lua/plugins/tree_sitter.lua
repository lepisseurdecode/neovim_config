return {
	'nvim-treesitter/nvim-treesitter',
	config = function()
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
}
