local parsers = {
	"markdown",
	"markdown_inline",
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
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup({})

		local function install_parsers()
			treesitter.install(parsers)
		end

		if vim.fn.executable("tree-sitter") == 1 then
			install_parsers()
		else
			-- On a fresh setup, wait for Mason to provide the CLI required by
			-- nvim-treesitter's new Neovim 0.12 branch before compiling parsers.
			vim.api.nvim_create_autocmd("User", {
				pattern = "MasonToolsUpdateCompleted",
				once = true,
				callback = install_parsers,
			})
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true }),
			callback = function(args)
				local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)

				if not language or not vim.list_contains(parsers, language) then
					return
				end

				local ok = pcall(vim.treesitter.start, args.buf, language)
				if ok then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
