---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- 	config = function()
			-- 		require("nvim-treesitter-textobjects").setup({
			-- 			select = {
			-- 				enable = true,
			-- 				lookahead = true,
			-- 				keymaps = {
			-- 					["af"] = "@function.outer",
			-- 					["if"] = "@function.inner",
			-- 				},
			-- 			},
			-- 		})
			-- 	end,
		},
		{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
	},
	build = ":TSUpdate",
	config = function()
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

		vim.schedule(function()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
					pcall(vim.treesitter.start, bufnr)
				end
			end
		end)
	end,
}
