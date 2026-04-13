local M = {}

M.lsp = { omnisharp = {} }
M.dap_adapters = { "coreclr" }

package.loaded["plugins.lang.csharp"] = M
return {}
