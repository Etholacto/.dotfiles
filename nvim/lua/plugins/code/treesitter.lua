---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{
			-- Textobjects are now configured through their own plugin, not inside
			-- nvim-treesitter setup (module system was removed in the rewrite).
			"nvim-treesitter/nvim-treesitter-textobjects",
			config = function()
				require("nvim-treesitter-textobjects").setup({
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
						},
					},
				})
			end,
		},
		{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
	},
	build = ":TSUpdate",
	config = function()
		-- The rewrite removed the module system (highlight, indent, autotag,
		-- smart_rename, textobjects). Highlighting is handled by neovim's
		-- built-in treesitter; parsers here just need to be installed.
		require("nvim-treesitter").setup({
			ensure_installed = {
				"c",
				"c_sharp",
				"cpp",
				"comment",
				"gdscript",
				"gdshader",
				"godot_resource",
				"glsl",
				"java",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"sql",
				"vim",
				"vimdoc",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"jsonc",
			},
			sync_install = false,
			highlight = { enable = true },
		})
	end,
}
