return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	opts = {
		formatters_by_ft = {
			python = { "ruff_format" },
		},
	},

	config = function(_, opts)
		local conform = require("conform")

		conform.setup(opts)

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.py",
			callback = function(args)
				conform.format({
					bufnr = args.buf,
					async = false,
					timeout_ms = 500,
				})
			end,
		})
	end,
}
