return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				cpp = { "clang_format" },
				c = { "clang_format " },
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
			},
			formatters = {
				clang_format = {
					args = { "--style=file:" .. vim.fn.stdpath("config") .. "/lua/plugins/lang/.clang-format" },
				},
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
