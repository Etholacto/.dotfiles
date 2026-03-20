local M = {}

M.lsp = {
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				diagnostics = { globals = { "vim" } },
			},
		},
	},
}

M.formatters = { "stylua" }

package.loaded["plugins.lang.lua"] = M
return {}
