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

-- Tree-sitter folding is disabled because its asynchronous fold update can
-- race with Prettier changing the buffer during format-on-save. Before
-- restoring it, confirm Neovim prevents vim.treesitter.foldexpr() callbacks
-- from calling vim._foldupdate() with a stale range after lines are added or
-- removed (related tracker: https://github.com/neovim/neovim/issues/32759).
-- Do not rely only on the issue status: after updating Neovim, temporarily
-- restore it and repeatedly save a Markdown file which Prettier changes.
-- Confirm that this Neovim error no longer appears:
--   vim.schedule callback: .../vim/treesitter/_fold.lua:...: invalid bot
--
-- Restore automatic Tree-sitter folds with these two lines:
-- vim.opt_local.foldmethod = "expr"
-- vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Then disable mkdnflow's folds module in lua/plugins/markdown.lua.
-- Until then, mkdnflow provides manual, heading-aware section folds.
vim.opt_local.foldmethod = "manual"
vim.opt_local.foldexpr = "0"
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99
