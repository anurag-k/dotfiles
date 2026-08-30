local config = function()
	local lspconfig = require("lspconfig")
	local keymap = vim.keymap
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

	-- Python
	lspconfig.pyright.setup({})
	lspconfig.ruff.setup({})

	-- YAML
	lspconfig.yamlls.setup({})

	-- TOML
	lspconfig.taplo.setup({})

	-- JavaScript / TypeScript
	lspconfig.ts_ls.setup({})

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local shellcheck = require("efmls-configs.linters.shellcheck")

	--configure efm server
	lspconfig.efm.setup({
		filetypes = {
			"lua",
			"sh",
			"bash",
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
				sh = { shellcheck },
				bash = { shellcheck },
			},
		},
	})

	-- LSP Keymaps
	keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

	keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
	keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
	keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
	keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
	keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })

	keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
	keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

	keymap.set("n", "<leader>cf", function()
		if vim.bo.filetype == "python" or vim.bo.filetype == "sh" or vim.bo.filetype == "bash" then
			require("conform").format({ async = true })
		else
			vim.lsp.buf.format({ async = true })
		end
	end, { desc = "Format Buffer" })
	keymap.set("n", "<leader>ci", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
	keymap.set("n", "<leader>df", vim.diagnostic.open_float, {
		desc = "Diagnostics",
	})

	keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, { desc = "Next Diagnostic" })

	keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, { desc = "Previous Diagnostic" })

	-- Format on Save
	local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {
		clear = true,
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
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
