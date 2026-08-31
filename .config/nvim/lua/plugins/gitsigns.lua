-- Gitsigns
--
-- Keymaps:
--   <leader>gb  Toggle current-line Git blame

local config = function()
	require("gitsigns").setup({
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},

		-- Show Git blame only on the current line.
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
		},
		current_line_blame_formatter = "  <author> • <author_time>",
		current_line_blame_formatter_nc = "  <author> • <author_time>",

		-- Toggle current-line Git blame.
		on_attach = function(bufnr)
			vim.keymap.set("n", "<leader>gb", function()
				require("gitsigns").toggle_current_line_blame()
			end, {
				buffer = bufnr,
				desc = "Toggle Git blame",
			})
		end,
	})
end

return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	config = config,
}
