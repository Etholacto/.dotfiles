return { -- Useful plugin to show you pending keybinds.
	'folke/which-key.nvim',
	event = 'VimEnter',
	opts = {
		preset = "helix",
		spec = {
			{
				mode = { "n", "v" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "File/Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>q", group = "Session" },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Toggle", icon = { icon = "󰙵 ", color = "cyan" } },
				{ "<leader>x", group = "Diagnostics/Quickfix", icon = { icon = "󱖫 ", color = "green" } },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gs", group = "surround" },
				{ "z", group = "fold" },
				{
					"<leader>w",
					group = "Windows",
					proxy = "<c-w>",
					expand = function()
						return require("which-key.extras").expand.win()
					end,
				},
			},
		}
	}
}
