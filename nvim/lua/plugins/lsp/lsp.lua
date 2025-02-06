return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = function()
		--Turn on and off the Logging done by nvim
		vim.lsp.set_log_level("debug")

		-- Add keybinds to the attached lsp
		local on_attach = function(client, bufnr)
			local tsb = require("telescope.builtin")
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })

			vim.keymap.set("n", "gd", tsb.lsp_definitions, { desc = "LSP: Goto Definition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Goto Declaration" })
			vim.keymap.set("n", "gr", tsb.lsp_references, { desc = "LSP: Goto Reference" })
			vim.keymap.set("n", "gI", tsb.lsp_implementations, { desc = "LSP: Goto Implementation" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
		end

		-- Change the Diagnostic symbols in the sign columns
		local x = vim.diagnostic.severity
		vim.diagnostic.config({
			signs = { text = { [x.ERROR] = "", [x.WARN] = "", [x.INFO] = "", [x.HINT] = "" } },
		})

		local mason_lspconfig = require("mason-lspconfig")

		-- Nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Attach capabilities and keybinds in attach
		mason_lspconfig.setup_handlers({
			function(server_name)
				if server_name ~= "jdtls" then
					local opts = {
						capabilities = capabilities,
						on_attach = on_attach,
					}
					if server_name == "clangd" then
						opts.cmd = { "clangd", "--compile-commands-dir=_project" }
					elseif server_name == "lua_ls" then
						opts.settings = {
							Lua = {
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
								diagnostics = { globals = { "vim" } },
							},
						}
					end
					require("lspconfig")[server_name].setup(opts)
				end
			end,
		})

		-- Can't add 'gdscript' to servers, not listed on Mason. Manually configure via lspconfig
		local gdscript_config = {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {},
		}
		require("lspconfig").gdscript.setup(gdscript_config)
	end,
}
