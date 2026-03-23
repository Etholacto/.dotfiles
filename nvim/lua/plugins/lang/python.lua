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
			{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
		},
		config = function()
			local is_win = vim.fn.has("win32") == 1
			local home = vim.fn.expand("~")

			local search
			if is_win then
				search = {
					-- Local venvs in the current project or workspace
					cwd = {
						command = "$FD Scripts\\\\python.exe$ $CWD --full-path --color never -HI -a -L",
					},
					workspace = {
						command = "$FD Scripts\\\\python.exe$ $WORKSPACE_PATH --full-path --color never -HI -a -L",
					},
				}

				-- Add conda searches for any base dirs that actually exist
				local conda_bases = {
					{ name = "conda", path = home .. "\\.conda" },
					{ name = "anaconda", path = home .. "\\anaconda3" },
					{ name = "miniconda", path = home .. "\\miniconda3" },
					{ name = "sys_anaconda", path = "C:\\ProgramData\\anaconda3" },
					{ name = "sys_miniconda", path = "C:\\ProgramData\\miniconda3" },
				}
				for _, c in ipairs(conda_bases) do
					if vim.fn.isdirectory(c.path) == 1 then
						-- Base environment python is one level deep
						search[c.name .. "_base"] = {
							command = "$FD python.exe " .. c.path .. " --max-depth 1 --full-path -a --color never",
							type = "anaconda",
						}
						-- Named environments are under envs/
						if vim.fn.isdirectory(c.path .. "\\envs") == 1 then
							search[c.name .. "_envs"] = {
								command = "$FD python.exe$ "
									.. c.path
									.. "\\envs --no-ignore-vcs --full-path -a -E Lib",
								type = "anaconda",
							}
						end
					end
				end
			else
				local conda_bases = {
					{ name = "anaconda", path = home .. "/.conda" },
					{ name = "miniconda", path = home .. "/miniconda3" },
					{ name = "sys_conda", path = "/opt/conda" },
				}

				search = {
					cwd = {
						command = "$FD '/bin/python$' '$CWD' --full-path --color never -HI -a -L -E /proc -E site-packages/",
					},
					workspace = {
						command = "$FD '/bin/python$' '$WORKSPACE_PATH' --full-path --color never -HI -a -L",
					},
				}

				for _, c in ipairs(conda_bases) do
					if vim.fn.isdirectory(c.path) == 1 then
						search[c.name .. "_base"] = {
							command = "$FD '/bin/python$' " .. c.path .. " --max-depth 2 --full-path --color never",
							type = "anaconda",
						}
						if vim.fn.isdirectory(c.path .. "/envs") == 1 then
							search[c.name .. "_envs"] = {
								command = "$FD 'bin/python$' "
									.. c.path
									.. "/envs --no-ignore-vcs --full-path --color never",
								type = "anaconda",
							}
						end
					end
				end
			end

			require("venv-selector").setup({
				options = {
					notify_user_on_venv_activation = true,
				},
				search = search,
			})

			-- lazy.nvim's ft-loading re-fires FileType buffer-locally, skipping
			-- pattern-based autocmds (like vim.lsp.enable's FileType handler).
			-- Explicitly re-fire so basedpyright attaches on the first Python file.
			vim.api.nvim_exec_autocmds("FileType", { pattern = "python" })
		end,
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

--Debugpy in formatter since it could interfere with nvim-dap-python setup if its in regular debugger
M.formatters = { "debugpy", "isort", "black" }

package.loaded["plugins.lang.python"] = M
return M
