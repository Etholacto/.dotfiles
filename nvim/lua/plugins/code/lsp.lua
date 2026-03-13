---@diagnostic disable: missing-fields
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			"j-hui/fidget.nvim",
			event = "LspAttach",
			opts = {},
		},
		"saghen/blink.cmp",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ "nvim-dap-ui" },
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = " ",
					package_pending = " ",
					package_uninstalled = " ",
				},
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				map("gd", function()
					vim.lsp.buf.definition()
				end, "Goto Definition")
				map("gD", function()
					vim.lsp.buf.declarations()
				end, "Goto Declaration")
				map("gr", function()
					vim.lsp.buf.references()
				end, "References")
				map("gI", function()
					vim.lsp.buf.implementations()
				end, "Goto Implementation")
				map("gy", function()
					vim.lsp.buf.type_definitions()
				end, "Goto Type Definition")
				map("<leader>ss", function()
					vim.lsp.buf.document_symbol()
				end, "LSP Symbols")
				map("<leader>sS", function()
					vim.lsp.buf.workspace_symbol()
				end, "LSP Workspace Symbols")
				map("<leader>cr", vim.lsp.buf.rename, "Rename")
				-- map("<leader>cR", function()
				-- 	Snacks.rename.rename_file()
				-- end, "Rename File")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
				map("<leader>cf", vim.lsp.buf.format, "Code Format")
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				if client and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true)
				else
					vim.lsp.inlay_hint.enable(false)
				end
			end,
		})

		if vim.lsp.inlay_hint then
			vim.keymap.set("n", "<leader>ch", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "Toggle Inlay Hints" })
		end

		vim.diagnostic.config({
			virtual_text = {
				prefix = "", -- Could be '●', '▎', │, 'x', '■', , 
			},
			jump = {
				float = true,
			},
			float = { border = "single" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
			},
		})

		-- Nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

		local servers = {
			clangd = {
				cmd = {
					"clangd",
				},
			},
			ltex = {
				filetypes = { "latex", "tex", "bib" },
			},
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = { globals = { "vim" } },
					},
				},
			},
			marksman = {},
			jdtls = {
				autostart = false,
			},
			jsonls = {},
			glsl_analyzer = {},
			omnisharp = {},
			pylsp = {},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", --Formater Lua
			"isort",  --Formater Python
			"black",  --Formater Python
			"clang-format", --Formater C,C++
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			automatic_enable = {
				exclude = {
					"jdtls"
				}
			},

			handlers = {
				function(server_name)
					if server_name ~= "jdtls" then
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						vim.lsp.config(server_name, server)
					end
				end,
			},
		})

		-- Can't add 'gdscript' to servers, not listed on Mason. Manually configure via lspconfig
		local gdscript_config = {
			capabilities = capabilities,
			settings = {},
		}
		vim.lsp.config("gdscript", gdscript_config)
	end,
}
