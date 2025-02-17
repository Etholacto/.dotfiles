return {
	{
		-- Quick changes to delimiter pairs
		'kylechui/nvim-surround',
		version = "*",
		event = "VeryLazy",
		opts = {}
	},
	{
		--Automatic pairing of delimiters
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup {}
		end
	},
	{
		-- Quick commenting of code
		'tpope/vim-commentary',
		event = 'VeryLazy',
	},
	{
		"andymass/vim-matchup",
		event = "BufRead",
		init = function()
			vim.g.matchup_override_vimtex = 1
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_offscreen = {}
			-- method = "popup",
			-- fullwidth = 0,
			-- syntax_hl = 1,
			-- }
		end,
	},
	{
		-- Automatic indentation of lines
		"lukas-reineke/indent-blankline.nvim",
		event = 'BufRead',
		config = function()
			require("ibl").setup()
		end
	},
	{
		-- More functionality for connection between nvim and godot
		"habamax/vim-godot",
		event = "VimEnter"
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
}
