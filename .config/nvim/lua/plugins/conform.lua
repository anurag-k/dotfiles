return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	opts = {
		formatters_by_ft = {
			markdown = { "prettier" },
			["markdown.mdx"] = { "prettier" },
			python = { "ruff_format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
		},
	},

	config = function(_, opts)
		local conform = require("conform")

		conform.setup(opts)

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.py", "*.md", "*.markdown", "*.mdx" },
			callback = function(args)
				conform.format({
					bufnr = args.buf,
					async = false,
					timeout_ms = 1000,
				})
			end,
		})
	end,
}
