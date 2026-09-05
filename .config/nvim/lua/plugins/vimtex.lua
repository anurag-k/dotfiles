return {
	{
		"lervag/vimtex",
		lazy = false,

		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
		end,

		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function(event)
					vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", {
						buffer = event.buf,
						desc = "Compile LaTeX document",
					})

					vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", {
						buffer = event.buf,
						desc = "View LaTeX PDF",
					})
				end,
			})
		end,
	},
}
