return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		-- Required for treesitter-aware node selections (ts_node surrounds).
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-surround").setup({})
	end,
}
