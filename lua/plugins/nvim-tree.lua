return {
	{
		"nvim-tree/nvim-tree.lua",
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		keys = "<F3>",
		config = function()
			require("nvim-tree").setup()
			vim.keymap.set(
				"n",
				"<F3>",
				require("nvim-tree.api").tree.toggle,
				{ desc = "Toggle nvim-tree", noremap = true, silent = true, nowait = true }
			)
			vim.defer_fn(require("nvim-tree.api").tree.toggle, 0)
		end,
	},
}
