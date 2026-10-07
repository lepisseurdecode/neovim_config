return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			vim.lsp.config("ltex_plus", {
				settings = {
					ltex = {
						language = "fr-FR",
					},
				},
			})
			vim.keymap.set(
				"n",
				"<c-w>D",
				vim.lsp.buf.code_action,
				{ desc = "Code Action", noremap = true, silent = true, nowait = true }
			)
		end,
	},
}
