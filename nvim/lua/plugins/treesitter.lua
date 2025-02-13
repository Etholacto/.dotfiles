return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"romgrk/nvim-treesitter-context",
	},
	build = ':TSUpdate',
	config = function(_, opts)
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				'c',
				'c_sharp',
				'cpp',
				'gdscript',
				'gdshader',
				'godot_resource',
				'glsl',
				'java',
				'python',
				'lua',
				'comment',
				'sql',
				'vim',
				'vimdoc',
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
		})
	end
}
