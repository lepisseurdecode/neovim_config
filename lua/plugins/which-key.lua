return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<F10>",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Help keymaps",
			},
		},
	},
}
