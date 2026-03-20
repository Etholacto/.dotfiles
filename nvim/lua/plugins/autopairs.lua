return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			-- Use treesitter to determine context: don't pair inside strings,
			-- comments, or other nodes where auto-pairing would be wrong.
			check_ts = true,
			ts_config = {
				-- Don't pair `'` or `"` inside Lua string nodes
				lua = { "string" },
				-- Don't pair backticks inside JS template literals
				javascript = { "template_string" },
			},

			-- check that the current line doesn't already have an unmatched
			-- closing bracket.	
			enable_check_bracket_line = true,

			-- Also check treesitter before each pair action.
			enable_moveright = true,

			-- Fast-wrap (<Alt-e>): wrap the next word/motion in a chosen pair
			-- without leaving insert mode. Useful for wrapping existing text.
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				highlight = "Search",
				highlight_grey = "Comment",
			},
		})
	end,
}
