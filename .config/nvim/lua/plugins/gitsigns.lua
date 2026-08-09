local config = function()
	require("gitsigns").setup({
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})
end

return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	config = config,
}
