return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
		},
	},
	version = "*",
	opts = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		snippets = { preset = "luasnip" },
		sources = {
			default = { "snippets", "lsp", "path", "buffer" },
			-- Dadbod completion scoped to SQL filetypes only.
			per_filetype = {
				sql   = { "dadbod", "snippets", "lsp", "path" },
				mysql = { "dadbod", "snippets", "lsp", "path" },
				plsql = { "dadbod", "snippets", "lsp", "path" },
			},
			providers = {
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
				},
			},
		},
		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
		},
	},
	opts_extend = { "sources.default" },
}
