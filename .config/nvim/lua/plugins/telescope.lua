-- Telescope
--
-- Keymaps:
--   <leader>fk  Telescope keymaps
--   <leader>fh  Telescope help tags
--   <leader>ff  Find files
--   <leader>fa  Telescope pickers
--   <leader>fg  Live grep
--   <leader>fG  Grep history
--   <leader>fb  Buffers
--   <leader>fr  Recent files
--   <leader>fR  Resume previous Telescope picker
--   <leader>gf  Git files

local keymap = vim.keymap

local config = function()
	local telescope = require("telescope")
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.config").values

	local history_file = vim.fn.stdpath("data") .. "/telescope_grep_history"

	local function load_grep_history()
		local history = {}

		if vim.fn.filereadable(history_file) == 1 then
			for _, line in ipairs(vim.fn.readfile(history_file)) do
				if line ~= "" then
					table.insert(history, line)
				end
			end
		end

		return history
	end

	local function save_grep_history(query)
		if query == "" then
			return
		end

		local history = load_grep_history()

		-- Remove an existing occurrence so the newest search moves to the top.
		for i = #history, 1, -1 do
			if history[i] == query then
				table.remove(history, i)
			end
		end

		table.insert(history, 1, query)

		-- Keep the history reasonably small.
		while #history > 50 do
			table.remove(history)
		end

		vim.fn.writefile(history, history_file)
	end

	local function live_grep()
		builtin.live_grep({
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local query = action_state.get_current_line()
					save_grep_history(query)

					actions.select_default(prompt_bufnr)
				end)

				return true
			end,
		})
	end

	local function grep_history()
		local history = load_grep_history()

		if #history == 0 then
			vim.notify("No grep history yet", vim.log.levels.INFO)
			return
		end

		pickers
			.new({}, {
				prompt_title = "Grep History",
				finder = finders.new_table({
					results = history,
				}),
				sorter = sorters.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local entry = action_state.get_selected_entry()

						if not entry then
							return
						end

						actions.close(prompt_bufnr)

						builtin.live_grep({
							default_text = entry[1],
						})
					end)

					return true
				end,
			})
			:find()
	end

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

	-- Replace the normal live_grep command with the history-aware version.
	keymap.set("n", "<leader>fg", live_grep, {
		desc = "Live grep",
	})

	keymap.set("n", "<leader>fG", grep_history, {
		desc = "Grep history",
	})

	keymap.set("n", "<leader>fR", builtin.resume, {
		desc = "Resume Telescope",
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

		keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", {
			desc = "Buffers",
		}),

		keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", {
			desc = "Recent files",
		}),

		keymap.set("n", "<leader>gf", ":Telescope git_files<CR>", {
			desc = "Git files",
		}),
	},
}
