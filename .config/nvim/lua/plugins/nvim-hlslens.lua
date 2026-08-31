return {
	"kevinhwang91/nvim-hlslens",
	lazy = false,
	config = function()
		local hlslens = require("hlslens")

		hlslens.setup({})

		local function search_with_lens(motion)
			return function()
				vim.cmd("normal! " .. vim.v.count1 .. motion)
				hlslens.start()
			end
		end

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "n", search_with_lens("n"), opts)
		vim.keymap.set("n", "N", search_with_lens("N"), opts)
		vim.keymap.set("n", "*", search_with_lens("*"), opts)
		vim.keymap.set("n", "#", search_with_lens("#"), opts)
		vim.keymap.set("n", "g*", search_with_lens("g*"), opts)
		vim.keymap.set("n", "g#", search_with_lens("g#"), opts)
	end,
}
