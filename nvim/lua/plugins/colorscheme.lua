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
	end,
}
