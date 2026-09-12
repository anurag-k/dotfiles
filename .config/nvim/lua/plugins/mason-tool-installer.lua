return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	lazy = false,
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		ensure_installed = {
			"marksman",
			"prettier",
			"tree-sitter-cli",
		},
		run_on_start = true,
		start_delay = 3000,
		debounce_hours = 24,
	},
}
