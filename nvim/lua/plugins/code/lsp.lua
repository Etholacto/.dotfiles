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
					vim.lsp.buf.declaration()
				end, "Goto Declaration")
				map("gr", function()
					vim.lsp.buf.references()
				end, "References")
				map("gI", function()
					vim.lsp.buf.implementation()
				end, "Goto Implementation")
				map("gy", function()
					vim.lsp.buf.type_definition()
				end, "Goto Type Definition")
				map("<leader>ss", function()
					vim.lsp.buf.document_symbol()
				end, "LSP Symbols")
				map("<leader>sS", function()
					vim.lsp.buf.workspace_symbol()
				end, "LSP Workspace Symbols")
				map("<leader>cr", vim.lsp.buf.rename, "Rename")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
				map("<leader>cf", function()
					require("conform").format({ lsp_format = "never" })
				end, "Code Format")
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
			update_in_insert = false,
			virtual_text = {
				prefix = "", -- Could be '●', '▎', │, 'x', '■', ,
			},
			jump = {
				on_jump = function(diagnostic, bufnr)
					if not diagnostic then
						return
					end
					vim.diagnostic.show(
						diagnostic.namespace,
						bufnr,
						{ diagnostic },
						{ virtual_lines = { current_line = true }, virtual_text = false }
					)
				end,
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

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

		local servers = {}
		local lang_modules = {}

		for name, ftype in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/lang") do
			if ftype == "file" and name:match("%.lua$") then
				table.insert(lang_modules, require("lang." .. name:gsub("%.lua$", "")))
			end
		end

		local extra_tools = {}
		for _, lang in ipairs(lang_modules) do
			if lang.lsp then
				servers = vim.tbl_deep_extend("force", servers, lang.lsp)
			end
			if lang.formatters then
				vim.list_extend(extra_tools, lang.formatters)
			end
		end

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, extra_tools)
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Configure each server before automatic_enable runs.
		for server_name, server in pairs(servers) do
			server = vim.tbl_deep_extend("force", {}, server)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			vim.lsp.config(server_name, server)
		end

		-- automatic_enable calls vim.lsp.enable() for every Mason-installed server.
		require("mason-lspconfig").setup({
			automatic_enable = { exclude = { "jdtls" } },
		})

		-- gdscript is not on Mason; configure and enable it manually.
		require("lang.godot").setup_lsp(capabilities)
		vim.lsp.enable("gdscript")

		vim.schedule(function()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
					local ft = vim.bo[bufnr].filetype
					if ft and ft ~= "" then
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("doautocmd FileType " .. ft)
						end)
					end
				end
			end
		end)
	end,
}
