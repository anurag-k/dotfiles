return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		keymap = {
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Esc>"] = { "cancel", "fallback" },
		},

		completion = {
			documentation = {
				auto_show = true,
			},
		},

		sources = {
			default = { "lsp", "path", "buffer" },
		},
	},
}
