local M = {
	"lervag/vimtex",
	ft = { "tex", "plaintex", "bib" },
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_latexmk = { out_dir = "out" }
		-- Disable vimtex's K mapping so it doesn't shadow LSP hover.
		vim.g.vimtex_mappings_disable = { n = { "K" } }
		-- Use pplatex for nicer quickfix output if available, else latexlog.
		vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
	end,
}

-- texlab is a proper LaTeX LSP (completion, build integration, forward-search).
-- Replaces the generic ltex grammar checker that was in lsp.lua's base servers.
M.lsp = {
	texlab = {
		settings = {
			texlab = {
				build = { onSave = false }, -- builds controlled via vimtex
				forwardSearch = {
					executable = "zathura",
					args = { "--synctex-forward", "%l:1:%f", "%p" },
				},
				chktex = { onOpenAndSave = true },
			},
		},
	},
}

M.formatters = { "latexindent" }

return M
