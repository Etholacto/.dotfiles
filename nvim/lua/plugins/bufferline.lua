return {
	"akinsho/bufferline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "buffer",
				numbers = "none",
				diagnostics = false,
				separator_style = "slant",
				show_buffer_icons = false,
				show_buffer_close_icons = false,
				show_close_icon = false,
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				show_tab_indicators = true,
				style_preset = {
					bufferline.style_preset.no_bold,
					bufferline.style_preset.no_italic,
				},
				offsets = {
					{
						filetype = "dbui",
						text = "DB UI",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
			highlights = {
				fill = {
					bg = "#1f1f28",
				},
				indicator_selected = {
					fg = "#717c7c",
					bg = "#363646",
				},
				modified = {
					fg = "#76946A",
				},
				modified_selected = {
					fg = "#98BB6C",
					bg = "#1f1f28",
				},
				separator_selected = {
					fg = "#1f1f28",
				},
				separator_visible = {
					fg = "#1F1F28",
				},
				separator = {
					fg = "#1f1f28",
				},
				trunc_marker = {
					bg = "#1f1f28",
				},
			},
		})
	end,
}
