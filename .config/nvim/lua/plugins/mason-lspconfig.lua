local opts = {
	ensure_installed = {
		"lua_ls",
		"clangd",
		"pyright",
		"bashls",
		"jsonls",
		"yamlls",
		"ts_ls",
	},
	automatic_installation = false,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
