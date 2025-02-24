return {
	{
		-- More functionality for connection between nvim and godot
		"habamax/vim-godot",
		ft = "gdscript",
		event = "BufReadPre",
	},
	{
		-- Changes background to match colour (Hex, names var, etc.)
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},
	{
		-- Highlights todo sections
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = vim.opt.sessionoptions:get() },
		-- stylua: ignore
		keys = {
			{ "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
			{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
			{ "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
		},
	},
	{
		"utilyre/barbecue.nvim",
		event = { "BufReadPre", "BufNewFile" },
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},
}
