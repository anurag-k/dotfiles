local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Directory Navigation
keymap.set("n", "<leader>m", "<cmd>NvimTreeFocus<CR>", opts) -- Focus file tree
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts) -- Toggle file tree

-- Pane Navigation
keymap.set("n", "<C-h>", "<C-w>h", opts) -- Navigate Left
keymap.set("n", "<C-j>", "<C-w>j", opts) -- Navigate Down
keymap.set("n", "<C-k>", "<C-w>k", opts) -- Navigate Up
keymap.set("n", "<C-l>", "<C-w>l", opts) -- Navigate Right

-- Window Management
keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", opts) -- Split Vertically
keymap.set("n", "<leader>sh", "<cmd>split<CR>", opts) -- Split Horizontally
keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", opts) -- Toggle Maximize

-- Buffer Navigation
keymap.set("n", "<C-Tab>", "<cmd>b#<CR>", {
	desc = "Switch to previous buffer",
})

-- Terminals may not transmit a distinct Ctrl-Tab sequence.
keymap.set("n", "<leader><Tab>", "<cmd>b#<CR>", {
	desc = "Switch to previous buffer",
})

-- Indenting
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")

-- Comments
-- Use gcc / gc for commenting (Comment.nvim)
