-- Keep prose readable without changing the editing defaults used by code files.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "shift:2,min:20"
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us" }
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "nc"
vim.opt_local.colorcolumn = ""

-- Tree-sitter folds follow the document's heading structure and start open.
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99

