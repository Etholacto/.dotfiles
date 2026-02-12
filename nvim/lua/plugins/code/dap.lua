return {
	"mfussenegger/nvim-dap",
	event = "BufRead",
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

		require("mason").setup()

		vim.g.mason_nvim_dap_python_path =
			"C:\\Users\\ckornack\\AppData\\Local\\Programs\\Python\\Python313\\python.exe"
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			ensure_installed = {
				"coreclr",
				"cpptools",
				"javadbg",
				"javatest",
				"python",
			},
			handlers = {},
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
		keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Set Breakpoint" })

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		-- dap.listeners.after.event_terminated.dapui_config = function()
		-- 	dapui.close()
		-- end
		-- dap.listeners.after.event_exited.dapui_config = function()
		-- 	dapui.close()
		-- end

		local function get_python_path()
			local cwd = vim.fn.getcwd()
			local is_win = vim.fn.has("win32") == 1

			local candidates

			if is_win then
				candidates = {
					cwd .. "\\env\\Scripts\\python.exe",
					cwd .. "\\venv\\Scripts\\python.exe",
					cwd .. "\\.venv\\Scripts\\python.exe",
				}
			else
				candidates = {
					cwd .. "/env/bin/python",
					cwd .. "/venv/bin/python",
					cwd .. "/.venv/bin/python",
				}
			end

			for _, path in ipairs(candidates) do
				if vim.fn.executable(path) == 1 then
					return path
				end
			end

			-- Final fallback: system python
			return vim.fn.exepath("python")
		end

		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				---@diagnostic disable-next-line: undefined-field
				local port = (config.connect or config).port
				---@diagnostic disable-next-line: undefined-field
				local host = (config.connect or config).host or "127.0.0.1"
				cb({
					type = "server",
					port = assert(port, "`connect.port` is required for a python `attach` configuration"),
					host = host,
					options = {
						source_filetype = "python",
					},
				})
			else
				cb({
					type = "executable",
					command = vim.fn.stdpath("data") .. "\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe",
					args = { "-m", "debugpy.adapter" },
					options = {
						source_filetype = "python",
					},
				})
			end
		end

		dap.configurations.python = {
			{
				-- The first three options are required by nvim-dap
				type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = "launch",
				name = "Launch file",
				-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
				program = "${file}", -- This configuration will launch the current file if used.
				pythonPath = get_python_path(),
			},
		}

		--Godot config
		dap.adapters.godot = {
			type = "server",
			host = "127.0.0.1",
			port = 6006,
		}

		dap.configurations.gdscript = {
			{
				type = "godot",
				request = "launch",
				name = "Launch scene",
				project = "${workspaceFolder}",
				launch_scene = true,
			},
		}

		--Java config
		dap.configurations.java = {
			{
				type = "java",
				name = "Debug (Attach)",
				request = "attach",
				hostName = "127.0.0.1",
				port = 5005,
			},
		}
	end,
}
