return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local kanagawa = require("kanagawa")
		kanagawa.setup({
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
							float = {
								bg = "none"
							}
						}
					}
				}
			}
		})
		vim.cmd("colorscheme kanagawa")
		vim.api.nvim_set_hl(0, "FloatBorder", {fg = "#54546D", bg = "#1F1F28"})
		vim.api.nvim_set_hl(0, "FloatTitle", {fg = "#938AA9", bg = "#1F1F28"})
	end,
}
