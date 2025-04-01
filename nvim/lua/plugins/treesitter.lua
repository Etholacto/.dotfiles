---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"romgrk/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
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
				"python",
				"sql",
				"vim",
				"vimdoc",
				"html",
				"css",
			},
			sync_install = true,
			highlight = { enable = true },
			indent = { enable = false },
			smart_rename = { enable = true },
			autotag = {
				enable = true,
				enable_rename = true,
				enable_close = true,
				enable_close_on_slash = true,
			},
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						-- Your custom capture.
						["aF"] = "@custom_capture",

						-- Built-in captures.
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
				},
			},
		})
	end,
}
