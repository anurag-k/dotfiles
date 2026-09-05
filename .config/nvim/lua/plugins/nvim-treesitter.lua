local config = function()
	require("nvim-treesitter.configs").setup({
		indent = {
			enable = true,
		},

		ensure_installed = {
			"markdown",
			"json",
			"javascript",
			"typescript",
			"yaml",
			"html",
			"css",
			"bash",
			"lua",
			"dockerfile",
			"solidity",
			"gitignore",
			"python",
			"vue",
			"cpp",
		},

		auto_install = true,
		-- VimTeX provides LaTeX syntax support. Excluding this parser also avoids
		-- auto-install failures when the tree-sitter CLI is not installed.
		ignore_install = { "latex" },

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	config = config,
}
