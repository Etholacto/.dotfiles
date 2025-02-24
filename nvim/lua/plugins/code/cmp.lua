return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		{
			'L3MON4D3/LuaSnip',
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = {
				{
					'rafamadriz/friendly-snippets',
					config = function()
						require('luasnip.loaders.from_vscode').lazy_load()
					end
				}
			}
		},
		'saadparwaiz1/cmp_luasnip',
		'hrsh7th/cmp-nvim-lsp',
		'onsails/lspkind.nvim',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local lspkind = require("lspkind")

		luasnip.config.setup {}

		-- Setup autocompletion window to preferences
		cmp.setup({
			completion = {
				completeopt = 'menu,menuone,noinsert',
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
				['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
				['<C-b>'] = cmp.mapping.scroll_docs(-4), -- scroll backward
				['<C-f>'] = cmp.mapping.scroll_docs(4), -- scroll forward
				['<C-Space>'] = cmp.mapping.complete {}, -- show completion suggestions
				['<CR>'] = cmp.mapping.confirm { select = true },
				-- Tab to the next argument
				['<Tab>'] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { 'i', 's' }),
				-- Tab backwards through suggestions or when a snippet is active, tab to the next argument
				['<S-Tab>'] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { 'i', 's' }),
			},
			--Specify order of cmp appearance
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- lsp
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					mode = 'symbol', -- show only symbol annotations
					ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					show_labelDetails = true, -- show labelDetails in menu. Disabled by default
				}),
			}
		})
		cmp.setup.filetype({ "sql" }, {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			}
		})
	end,
}
