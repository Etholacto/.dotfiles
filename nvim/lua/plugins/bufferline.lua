return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "buffer",
				numbers = "none",
				diagnostics = "nvim_lsp",
				separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				style_preset = {
					bufferline.style_preset.no_bold,
					bufferline.style_preset.no_italic,
				},
				offsets = {
					{
						filetype = "undotree",
						text = "Undo Tree",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "dbui",
						text = "DB UI",
						highlight = "Directory",
						text_align = "left",
					}
				},
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and "" or ""
					return "" .. icon .. ""
				end,
			},
		})
	end
}
