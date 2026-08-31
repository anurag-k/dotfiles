-- Telescope
--
-- Keymaps:
--   <leader>fk  Telescope keymaps
--   <leader>fh  Telescope help tags
--   <leader>ff  Find files
--   <leader>fa  Telescope pickers
--   <leader>fg  Live grep
--   <leader>fb  Buffers
--   <leader>fr  Recent files
--   <leader>fR  Resume previous Telescope picker
--   <leader>gf  Git files

local keymap = vim.keymap

local config = function()
	local telescope = require("telescope")

	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
				},
			},
		},

		pickers = {
			find_files = {
				theme = "dropdown",
				previewer = false,
				hidden = true,
			},

			live_grep = {
				theme = "dropdown",
				previewer = false,
			},

			find_buffers = {
				theme = "dropdown",
				previewer = false,
			},
		},
	})
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	lazy = false,

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = config,

	keys = {
		keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", {
			desc = "Telescope keymaps",
		}),

		keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", {
			desc = "Telescope help tags",
		}),

		keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {
			desc = "Find files",
		}),

		keymap.set("n", "<leader>fa", ":Telescope<CR>", {
			desc = "Telescope pickers",
		}),

		keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", {
			desc = "Live grep",
		}),

		keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", {
			desc = "Buffers",
		}),

		keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", {
			desc = "Recent files",
		}),

		keymap.set("n", "<leader>fR", require("telescope.builtin").resume, {
			desc = "Resume Telescope",
		}),

		keymap.set("n", "<leader>gf", ":Telescope git_files<CR>", {
			desc = "Git files",
		}),
	},
}
