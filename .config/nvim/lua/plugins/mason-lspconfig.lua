local opts = {
	ensure_installed = {
		"lua_ls",
		"clangd",
		"pyright",
		"bashls",
		"jsonls",
		"yamlls",
		"ts_ls",
		"marksman",
	},
	automatic_installation = false,
	-- Servers are enabled explicitly in nvim-lspconfig.lua; avoid starting tools like stylua as LSP servers.
	automatic_enable = false,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
