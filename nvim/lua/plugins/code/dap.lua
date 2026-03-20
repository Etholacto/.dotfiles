---@diagnostic disable: missing-fields
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {
				commented = true,
				virt_text_pos = "eol",
			},
		},
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			automatic_installation = true,
			ensure_installed = {
				"coreclr",
				"codelldb",
				"javadbg",
				"javatest",
				"js-debug-adapter",
			},
			handlers = {
				--Prevent mason to override the nvim-dap-python setup
				python = function() end,
			},
		})

		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "󰋗", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
		)
		vim.fn.sign_define("DapBreakpointRejected", { text = "󰅙", texthl = "Comment", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticOk", linehl = "", numhl = "DiagnosticOk" })

		local keymap = vim.keymap
		keymap.set("n", "<F2>", dap.clear_breakpoints, { desc = "Remove All Breakpoints" })
		keymap.set("n", "<F3>", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Set Breakpoint" })
		keymap.set("n", "<F4>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "Start/Continue" })
		keymap.set("n", "<F6>", function()
			dapui.close()
			dap.terminate()
		end, { desc = "End" })
		keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })
		keymap.set("n", "<F8>", dap.step_over, { desc = "Step Over" })
		keymap.set("n", "<F9>", dap.step_out, { desc = "Step Out" })
		keymap.set("n", "<F10>", dap.run_to_cursor, { desc = "To Cursor" })
		keymap.set({ "n", "v" }, "<Leader>dh", function()
			require("dap.ui.widgets").hover()
		end)

		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.8 },
						{ id = "breakpoints", size = 0.2 },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{ id = "console", size = 0.8 },
						{ id = "repl", size = 0.2 },
					},
					position = "right",
					size = 40,
				},
			},
		})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		-- Language-specific adapter and config setup
		require("plugins.lang.clangd").setup_dap(dap)
		require("plugins.lang.godot").setup_dap(dap)
		require("plugins.lang.java").setup_dap(dap)
		require("plugins.lang.typescript").setup_dap(dap)
	end,
}
