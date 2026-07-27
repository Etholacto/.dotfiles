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

		local lang_modules = {
			require("lang.clangd"),
			require("lang.csharp"),
			require("lang.java"),
			require("lang.typescript"),
		}

		local dap_adapters = {}
		for _, lang in ipairs(lang_modules) do
			if lang.dap_adapters then
				vim.list_extend(dap_adapters, lang.dap_adapters)
			end
		end

		require("mason-nvim-dap").setup({
			automatic_installation = true,
			ensure_installed = dap_adapters,
			handlers = {
				-- Prevent mason-nvim-dap from overriding nvim-dap-python's setup
				python = function() end,
			},
		})

		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "󰋗", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
		)
		vim.fn.sign_define("DapBreakpointRejected", { text = "󰅙", texthl = "Comment", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticOk", linehl = "", numhl = "DiagnosticOk" })

		local keymap = vim.keymap
		keymap.set({ "n", "v" }, "<F2>", dap.clear_breakpoints, { desc = "Remove All Breakpoints" })
		keymap.set({ "n", "v" }, "<F3>", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Set Breakpoint" })
		keymap.set({ "n", "v" }, "<F4>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		keymap.set({ "n", "v" }, "<F5>", function()
			dap.continue()
		end, { desc = "Start/Continue" })
		keymap.set({ "n", "v" }, "<F6>", function()
			dapui.close()
			dap.terminate()
		end, { desc = "End" })
		keymap.set({ "n", "v" }, "<F7>", dap.step_into, { desc = "Step Into" })
		keymap.set({ "n", "v" }, "<F8>", dap.step_over, { desc = "Step Over" })
		keymap.set({ "n", "v" }, "<F9>", "<cmd>echo This doesnt do anything<cr>", { desc = "Restart DAP" })
		keymap.set({ "n", "v" }, "<F10>", dap.run_to_cursor, { desc = "To Cursor" })
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
		require("lang.clangd").setup_dap(dap)
		require("lang.godot").setup_dap(dap)
		require("lang.java").setup_dap(dap)
		require("lang.typescript").setup_dap(dap)
	end,
}
