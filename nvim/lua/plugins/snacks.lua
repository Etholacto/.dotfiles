return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			sections = {
				{
					section = "terminal",
					cmd =
					"chafa ~/Pictures/Desktop/MountainScenery.webp --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
					height = 17,
					padding = 1,
				},
				{
					pane = 2,
					{
						{ icon = " ", key = "f", desc = "File Browser", action = ":lua Snacks.picker.explorer()" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
						gap = 1,
						padding = 1
					},
					{ section = "startup" },
				},
			}
		},
		debug = { engabled = false },
		explorer = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		image = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		picker = {
			layouts = {
				default = {
					layout = {
						box = "horizontal",
						backdrop = false,
						width = 0.8,
						height = 0.9,
						{
							box = "vertical",
							{ win = "input", height = 1,         border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
							{ win = "list",  border = "rounded", title = "Results",  title_pos = "center" },
						},
						{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					}
				},
			},
			sources = {
				explorer = {
					auto_close = true,
					diagnostics = false,
					git_status = false,
					layout = {
						layout = {
							position = 'float',
							box = "horizontal",
							backdrop = false,
							width = 0.8,
							height = 0.9,
							{
								box = "vertical",
								{ win = "input", height = 1,         border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
								{ win = "list",  border = "rounded", title = "Results",  title_pos = "center" },
							},
							{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
						},
						preview = true
					}
				},
			}
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true } -- Wrap notifications
			}
		}
	},
	keys = {
		-- General
		{ "<leader>n",  function() Snacks.picker.notifications() end,      desc = "Notification History" },
		{ "<leader>tn", function() Snacks.notifier.hide() end,             desc = "Dismiss All Notifications" },
		-- Find
		{ "<leader>fb", function() Snacks.picker.explorer() end,           desc = "Explore Files" },
		{ "<leader>fc", function() Snacks.lazygit() end,                   desc = "Lazygit" },
		{ "<leader>ff", function() Snacks.picker.files() end,              desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.grep() end,               desc = "Grep" },
		{ "<leader>fp", function() Snacks.picker.projects() end,           desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() end,             desc = "Recent" },
		-- Git
		{ "<leader>gb", function() Snacks.picker.git_branches() end,       desc = "Git Branches" },
		{ "<leader>gB", function() Snacks.gitbrowse() end,                 desc = "Git Browse",               mode = { "n", "v" } },
		{ "<leader>gl", function() Snacks.picker.git_log() end,            desc = "Git Log" },
		{ "<leader>gL", function() Snacks.picker.git_log_line() end,       desc = "Git Log Line" },
		{ "<leader>gs", function() Snacks.picker.git_status() end,         desc = "Git Status" },
		{ "<leader>gS", function() Snacks.picker.git_stash() end,          desc = "Git Stash" },
		{ "<leader>gd", function() Snacks.picker.git_diff() end,           desc = "Git Diff (Hunks)" },
		{ "<leader>gf", function() Snacks.picker.git_log_file() end,       desc = "Git Log File" },
		-- Grep
		{ "<leader>sb", function() Snacks.picker.lines() end,              desc = "Buffer Lines" },
		{ "<leader>sB", function() Snacks.picker.grep_buffers() end,       desc = "Grep Open Buffers" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end,          desc = "Visual selection or word", mode = { "n", "x" } },
		-- Search
		{ '<leader>s"', function() Snacks.picker.registers() end,          desc = "Registers" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end,        desc = "Diagnostics" },
		{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
		{ "<leader>sh", function() Snacks.picker.help() end,               desc = "Help Pages" },
		{ "<leader>si", function() Snacks.picker.icons() end,              desc = "Icons" },
		{ "<leader>sm", function() Snacks.picker.man() end,                desc = "Man Pages" },
		{ "<leader>tu", function() Snacks.picker.undo() end,               desc = "Undo History" },
		{ "<leader>tc", function() Snacks.picker.colorschemes() end,       desc = "Colorschemes" },
		-- Other
		{ "<c-_>",      function() Snacks.terminal() end,                  desc = "which_key_ignore" },
		{ "<c-/>",      function() Snacks.terminal() end,                  desc = "Toggle Terminal" },
	},
}
