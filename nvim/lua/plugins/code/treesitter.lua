---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
		{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
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
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
