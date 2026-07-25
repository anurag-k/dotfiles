local config = function()
	local lspconfig = require("lspconfig")
	local signs = {
		Error = " ",
		Warn = " ",
		Hint = "󰌵 ",
		Info = " ",
	}
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- Diagnostics display settings
	vim.diagnostic.config({
		virtual_text = {
			prefix = "●", -- alternatives: "■", "▎", "x"
		},
		signs = true,
		update_in_insert = false,
		float = {
			border = "rounded",
			source = "always",
		},
	})

	-- lua
	lspconfig.lua_ls.setup({
		-- capabilities = capabilities,
		-- on_attach = on_attach,
		settings = { -- custom settings for lua
			Lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- make language server aware of runtime files
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})

	-- C++
	lspconfig.clangd.setup({
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--completion-style=detailed",
		},
	})

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	--configure efm server
	lspconfig.efm.setup({
		filetypes = {
			"lua",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				lua = { luacheck, stylua },
			},
		},
	})

	-- Format on Save
	local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = lsp_fmt_group,
		callback = function()
			local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
			for _, client in pairs(clients) do
				if
					client.name == "efm"
					and client.config
					and client.config.settings
					and client.config.settings.languages
				then
					vim.lsp.buf.format({
						name = "efm",
						bufnr = vim.api.nvim_get_current_buf(),
					})
					return
				end
			end
		end,
	})
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
	},
}
