local M = {}

M.plugins = {
	{
		"b0o/SchemaStore.nvim",
		lazy = true, -- loaded on demand inside on_new_config below
	},
}

M.lsp = {
	jsonls = {
		-- Inject SchemaStore schemas lazily the first time a JSON file is opened.
		on_new_config = function(new_config)
			new_config.settings = new_config.settings or {}
			new_config.settings.json = new_config.settings.json or {}
			new_config.settings.json.schemas =
				vim.list_extend(new_config.settings.json.schemas or {}, require("schemastore").json.schemas())
		end,
		settings = {
			json = {
				format = { enable = true },
				validate = { enable = true },
			},
		},
	},
}

M.formatters = { "prettier" }

return M
