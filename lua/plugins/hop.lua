return {
	"smoka7/hop.nvim",
	version = "*",
	init = function()
		vim.keymap.set(
			"n",
			"é",
			"<cmd>:HopWord<CR>",
			{ desc = "Hop word", noremap = true, silent = true, nowait = true }
		)
		vim.keymap.set(
			"n",
			"û",
			"<cmd>:HopLine<CR>",
			{ desc = "Hop Line", noremap = true, silent = true, nowait = true }
		)
	end,
	opts = {
		keys = "etovxqpdygfblzhckisuran",
		multi_windows = true,
	},
}
