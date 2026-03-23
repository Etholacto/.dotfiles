local M = {}

local inlay_hints = {
	enumMemberValues = { enabled = true },
	functionLikeReturnTypes = { enabled = true },
	parameterNames = { enabled = "literals" },
	parameterTypes = { enabled = true },
	propertyDeclarationTypes = { enabled = true },
	variableTypes = { enabled = false },
}

M.lsp = {
	vtsls = {
		settings = {
			typescript = { inlayHints = inlay_hints },
			javascript = { inlayHints = inlay_hints },
		},
	},
}

M.formatters = { "prettier" }
M.dap_adapters = { "js-debug-adapter" }

function M.setup_dap(dap)
	-- js-debug-adapter installed via mason-nvim-dap "js-debug-adapter" entry.
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				vim.fn.expand("$MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"),
				"${port}",
			},
		},
	}

	for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
		dap.configurations[lang] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach to process",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
	end
end

-- vtsls-specific keymaps: organize/add/remove imports.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not (client and client.name == "vtsls") then return end
		local map = function(keys, cmd, desc)
			vim.keymap.set("n", keys, "<Cmd>" .. cmd .. "<CR>", { buffer = args.buf, desc = "TS: " .. desc })
		end
		map("<leader>co", "VtsExec organizeImports",    "Organize Imports")
		map("<leader>cM", "VtsExec addMissingImports",  "Add Missing Imports")
		map("<leader>cu", "VtsExec removeUnusedImports","Remove Unused Imports")
	end,
})

package.loaded["plugins.lang.typescript"] = M
return {}
