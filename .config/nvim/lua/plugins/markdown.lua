local markdown_filetypes = { "markdown", "markdown.mdx" }

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = markdown_filetypes,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			heading = {
				sign = false,
			},
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			completions = {
				lsp = {
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<leader>mr",
				"<cmd>RenderMarkdown buf_toggle<cr>",
				ft = markdown_filetypes,
				desc = "Toggle rendered Markdown",
			},
			{
				"<leader>mp",
				"<cmd>RenderMarkdown preview<cr>",
				ft = markdown_filetypes,
				desc = "Open Markdown split preview",
			},
		},
	},

	{
		"jakewvincent/mkdnflow.nvim",
		ft = markdown_filetypes,
		opts = {
			filetypes = {
				markdown = true,
				mdx = "markdown.mdx",
			},
			modules = {
				maps = false,
				conceal = false,
				folds = false,
				foldtext = false,
				completion = true,
			},
			links = {
				style = "markdown",
				conceal = false,
			},
			tables = {
				format_on_move = true,
				auto_extend_rows = true,
			},
			on_attach = function(bufnr)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = bufnr,
						desc = desc,
						silent = true,
					})
				end

				map({ "n", "v" }, "<CR>", "<cmd>MkdnEnter<cr>", "Follow or create Markdown link")
				map("n", "<BS>", "<cmd>MkdnGoBack<cr>", "Go back in Markdown links")
				map("n", "]h", "<cmd>MkdnNextHeading<cr>", "Next Markdown heading")
				map("n", "[h", "<cmd>MkdnPrevHeading<cr>", "Previous Markdown heading")
				map("n", "]l", "<cmd>MkdnNextLink<cr>", "Next Markdown link")
				map("n", "[l", "<cmd>MkdnPrevLink<cr>", "Previous Markdown link")
				map({ "n", "v" }, "<leader>mc", "<cmd>MkdnToggleToDo<cr>", "Toggle Markdown task")
				map({ "n", "v" }, "<leader>ml", "<cmd>MkdnCreateLink<cr>", "Create Markdown link")
				map("n", "<leader>mb", "<cmd>MkdnGoBack<cr>", "Go back in Markdown links")
				map("n", "<leader>mB", "<cmd>MkdnGoForward<cr>", "Go forward in Markdown links")
				map("n", "<leader>mt", "<cmd>MkdnTableFormat<cr>", "Format Markdown table")
				map("i", "<Tab>", "<cmd>MkdnTab<cr>", "Next table cell or indent list")
				map("i", "<S-Tab>", "<cmd>MkdnSTab<cr>", "Previous table cell or dedent list")
			end,
		},
	},
}
