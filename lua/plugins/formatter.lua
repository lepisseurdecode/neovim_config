return {
	{
		"stevearc/conform.nvim",
		opts = {
			-- formatters must be configured locally
			formatters_by_ft = { ["_"] = { "trim_whitespace" } },
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 5000,
			},
		},
	},
}
