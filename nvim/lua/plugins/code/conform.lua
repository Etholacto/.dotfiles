return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				-- C-suite
				c   = { "clang_format" },
				cpp = { "clang_format" },
				-- Lua
				lua = { "stylua" },
				-- Python
				python = { "isort", "black" },
				-- Java
				java = { "google-java-format" },
				-- Web
				json             = { "prettier" },
				jsonc            = { "prettier" },
				markdown         = { "prettier" },
				["markdown.mdx"] = { "prettier" },
				typescript       = { "prettier" },
				javascript       = { "prettier" },
				typescriptreact  = { "prettier" },
				javascriptreact  = { "prettier" },
				-- LaTeX
				tex = { "latexindent" },
				bib = { "latexindent" },
				-- SQL
				sql   = { "sqlfluff" },
				mysql = { "sqlfluff" },
				plsql = { "sqlfluff" },
			},
			formatters = {
				clang_format = {
					args = { "--style=file:" .. vim.fn.stdpath("config") .. "/lua/plugins/lang/.clang-format" },
				},
				sqlfluff = {
					-- dialect can be overridden per-project via a .sqlfluff file
					args = { "format", "--dialect", "ansi", "-" },
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "never",
			},
		})
	end,
}
