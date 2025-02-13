return {
	"lervag/vimtex",
	lazy = false,
	ft = {'tex', 'bib'},
	init = function()
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_latexmk = {
			out_dir = 'out',
		}
	end
}
