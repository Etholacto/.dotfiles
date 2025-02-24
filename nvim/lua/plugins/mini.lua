return {
	{
		-- Quick changes to delimiter pairs
		"echasnovski/mini.surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "gsa", -- Add surrounding in Normal and Visual modes
					delete = "gsd", -- Delete surrounding
					find = "gsf", -- Find surrounding (to the right)
					find_left = "gsF", -- Find surrounding (to the left)
					highlight = "gsh", -- Highlight surrounding
					replace = "gsr", -- Replace surrounding
					update_n_lines = "gsn", -- Update `n_lines`
				},
			})
		end,
	},
	{
		-- Quick changes to delimiter pairs
		"echasnovski/mini.pairs",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.pairs").setup({
				-- Global mappings. Each right hand side should be a pair information, a
				-- table with at least these fields (see more in |MiniPairs.map|):
				-- - <action> - one of 'open', 'close', 'closeopen'.
				-- - <pair> - two character string for pair to be used.
				-- By default pair is not inserted after `\`, quotes are not recognized by
				-- `<CR>`, `'` does not insert pair after a letter.
				-- Only parts of tables can be tweaked (others will use these defaults).
				mappings = {
					["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
					["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
					["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
					["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },

					[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
					["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
					["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
					[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

					['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
					["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
					["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
				},
			})
		end,
	},
	{
		-- Quick changes to delimiter pairs
		"echasnovski/mini.comment",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({})
		end,
	},
	{
		-- Quick changes to delimiter pairs
		"echasnovski/mini.ai",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.ai").setup({})
		end,
	},
}
