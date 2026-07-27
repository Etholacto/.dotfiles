local M = {}

M.lsp = {
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		},
		capabilities = {
			offsetEncoding = { "utf-16" },
		},
		root_markers = {
			".clangd",
			"compile_commands.json",
			"compile_flags.txt",
			"CMakeLists.txt",
			".git",
		},
	},
}

M.formatters = { "clang-format" }
M.dap_adapters = { "codelldb" }

function M.setup_dap(dap)
	-- codelldb adapter — installed via mason-nvim-dap "codelldb" entry in dap.lua
	if not dap.adapters["codelldb"] then
		dap.adapters["codelldb"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}
	end

	for _, lang in ipairs({ "c", "cpp" }) do
		dap.configurations[lang] = {
			{
				type = "codelldb",
				request = "launch",
				name = "Launch file",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
			{
				type = "codelldb",
				request = "attach",
				name = "Attach to process",
				pid = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
	end
end

return M
