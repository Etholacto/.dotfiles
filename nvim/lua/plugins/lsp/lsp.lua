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


				map("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
				map("gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
				map("gr", function() Snacks.picker.lsp_references() end, "References")
				map("gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
				map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
				map("<leader>ss", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
				map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")
				map("<leader>cr", vim.lsp.buf.rename, 'Rename')
				map("<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
				map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
				map('<leader>cf', vim.lsp.buf.format, 'Code Format')
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
			vim.keymap.set('n', '<leader>ch', function()
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
			ltex = {},
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = { globals = { "vim", "Snacks" } },
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
