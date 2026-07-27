local M = {}

M.plugins = { { "habamax/vim-godot", ft = "gdscript", event = "BufReadPre" } }

M.lsp = {
	glsl_analyzer = {},
}

function M.setup_lsp(capabilities)
	vim.lsp.config("gdscript", {
		capabilities = capabilities,
		settings = {},
	})
end

function M.setup_dap(dap)
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
end

return M
