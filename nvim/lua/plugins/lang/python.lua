local M = {
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		config = function()
			local is_win = vim.fn.has("win32") == 1
			local debugpy_python = vim.fn.stdpath("data")
				.. "/mason/packages/debugpy/venv/"
				.. (is_win and "Scripts/python.exe" or "bin/python")
			require("dap-python").setup(debugpy_python)
		end,
	},
	{
		-- venv-selector: telescope/snacks picker for switching virtual envs.
		"linux-cultist/venv-selector.nvim",
		ft = "python",
		dependencies = {
			{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		keys = {
			{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
		},
		opts = {
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		},
	},
}

M.lsp = {
	basedpyright = {
		settings = {
			basedpyright = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	},
}

M.formatters = { "isort", "black" }

package.loaded["plugins.lang.python"] = M
return M
