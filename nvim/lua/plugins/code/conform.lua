return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				cpp = { "clang_format" },
				c = { "clang_format " },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			formatters = {
				clang_format = {
					args = { "--style=file:" .. vim.fn.stdpath("config") .. "/lua/plugins/lang/.clang-format" },
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "never",
			},
		})
	end,
}
