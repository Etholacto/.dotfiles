return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-telescope/telescope-file-browser.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"FabianWirth/search.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local search = require("search")

		telescope.setup({
			defaults = {
				layout_strategy = "flex",
				layout_config = {
					vertical = {
						prompt_position = "top",
						mirror = true,
					},
					horizontal = {
						prompt_position = "top",
						mirror = false,
					},
				},
				sorting_strategy = "ascending",
				path_display = { "truncate " },
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
				file_ignore_patterns = {},
				prompt_prefix = "> ",
				color_devicons = true,
				use_less = true,
				set_env = { ["COLORTERM"] = "truecolor" },
			},
			extensions = {
				file_browser = {
					hijack_netrw = true,
					no_ignore = true,
					hidden = true,
					collapse_dirs = true,
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob=!**/.git/*",
						"--glob=!**/.idea/*",
						"--glob=!**/.vscode/*",
						"--glob=!**/build/*",
						"--glob=!**/dist/*",
						"--glob=!**/yarn.lock",
						"--glob=!**/package-lock.json",
					},
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		telescope.load_extension("file_browser")
		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files" })
		keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
		keymap.set("n", "<leader>sw", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find current file" })
		keymap.set("n", "<leader>sg", function()
			search.open()
		end, { desc = "Find in Workspace" })
		keymap.set("n", "<leader>sG", builtin.grep_string, { desc = "Search word in Workspace" })
		keymap.set(
			"n",
			"<leader>fb",
			":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>",
			{ desc = "File browser in current buffer", noremap = true }
		)
		keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "Find man pages" })
	end,
}
