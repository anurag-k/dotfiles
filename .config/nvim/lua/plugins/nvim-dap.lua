return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")

		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "-i", "dap" },
		}

		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMain = false,
			},
		}

		-- Python
		dap.adapters.python = {
			type = "executable",
			command = vim.fn.getcwd() .. "/.venv/bin/python",
			args = { "-m", "debugpy.adapter" },
		}

		dap.configurations.python = {
			{
				name = "Launch Python file",
				type = "python",
				request = "launch",
				program = "${file}",
				pythonPath = function()
					return vim.fn.getcwd() .. "/.venv/bin/python"
				end,
			},
		}

		-- DAP keymaps
		local keymap = vim.keymap

		keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
		keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
		keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
	end,
}
