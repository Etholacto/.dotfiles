return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ 'williamboman/mason.nvim', opts = {} },
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		{
			'j-hui/fidget.nvim',
			event = "LspAttach",
			opts = {}
		},
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		require('mason').setup({
			ui = {
				icons = {
					package_installed = ' ',
					package_pending = ' ',
					package_uninstalled = ' ',
				},
			},
		})

		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or 'n'
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
				end

				map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
				map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
				map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
				map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
				map("<leader>rn", vim.lsp.buf.rename, '[R]e[n]ame')
				map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				map('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
				map('K', vim.lsp.buf.hover, 'Hover Documentation')

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				if client and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true)
				else
					vim.lsp.inlay_hint.enable(false)
				end
			end,
		})

		if vim.lsp.inlay_hint then
			vim.keymap.set('n', '<Space>ih', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = 'Toggle Inlay Hints' })
		end

		vim.diagnostic.config({
			virtual_text = {
				prefix = '', -- Could be '●', '▎', │, 'x', '■', , 
			},
			jump = {
				float = true,
			},
			float = { border = 'single' },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = ' ',
					[vim.diagnostic.severity.WARN] = ' ',
					[vim.diagnostic.severity.HINT] = '󰌶 ',
					[vim.diagnostic.severity.INFO] = ' ',
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
					[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
					[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
					[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
				},
			},
		})

		-- Nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		local servers = {
			bashls = {},
			clangd = {
				cmd = {
					"clangd"
				}
			},
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = { globals = { "vim" } },
					}
				}
			},
			jdtls = {
				autostart = false
			},
			jsonls = {},
			glsl_analyzer = {},
			omnisharp = {},
			pylsp = {},
			sqlls = {},
			texlab = {},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			'stylua', --Formater Lua
			'isort', --Formater Python
			'black', --Formater Python
		})
		require('mason-tool-installer').setup { ensure_installed = ensure_installed }

		require('mason-lspconfig').setup {
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
					require('lspconfig')[server_name].setup(server)
				end,
			},
		}

		-- Can't add 'gdscript' to servers, not listed on Mason. Manually configure via lspconfig
		local gdscript_config = {
			capabilities = capabilities,
			settings = {},
		}
		require("lspconfig").gdscript.setup(gdscript_config)
	end,
}
