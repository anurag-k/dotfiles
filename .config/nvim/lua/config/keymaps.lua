local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Directory Navigation
keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Pane keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-h>", "<C-w>h", opts) -- Navigate Left
keymap.set("n", "<C-j>", "<C-w>j", opts) -- Navigate Right
keymap.set("n", "<C-k>", "<C-w>k", opts) -- Navigate Up
keymap.set("n", "<C-l>", "<C-w>l", opts) -- Navigate Down

-- Window Management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- split vertically
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- Split Horizontally
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- Toggle Minimize

-- Indenting
-- keymap.set("v", ">", "<gv", opts) -- works with '>'
-- keymap.set("v", "<", ">gv", opts) -- works with Ctrl+'>'
-- gv above was supposed to retain block highlighting, so indentation can be continued but this is not happening

-- Comments (does not work)
-- vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { noremap = false })
-- vim.api.nvim_set_keymap("v", "<C-_>", "gcc", { noremap = false })
