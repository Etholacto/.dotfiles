return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  },
  config = function()

    -- Add keybinds to the attached lsp
    local on_attach = function(_, bufnr)
      local tsb = require('telescope.builtin')
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {desc = "LSP: Rename"})
      vim.keymap.set("n","<leader>ca", vim.lsp.buf.code_action, {desc = "LSP: Code Action"})

      vim.keymap.set("n","gd", tsb.lsp_definitions, {desc = "LSP: Goto Definition"})
      vim.keymap.set("n","gD", vim.lsp.buf.declaration, {desc = "LSP: Goto Declaration"})
      vim.keymap.set("n","gr", tsb.lsp_references, {desc = "LSP: Goto Reference"})
      vim.keymap.set("n","gI", tsb.lsp_implementations, {desc = "LSP: Goto Implementation"})
      vim.keymap.set("n","K", vim.lsp.buf.hover, {desc = "Hover Documentation"})
    end

    -- Change the Diagnostic symbols in the sign columns
    local x = vim.diagnostic.severity
    vim.diagnostic.config {
      signs = { text = { [x.ERROR] = "", [x.WARN] = "", [x.INFO] = "", [x.HINT] = "" } }
    }

    -- Lsp servers added on fresh install
    local servers = {
      bashls = {},
      clangd = {},
      cssls = {},
      html = {},
      jdtls = {},
      jsonls = {},
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = { globals = { "vim" } },
        },
      },
      omnisharp = {},
      pylsp = {},
      ts_ls = {},
    }

    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- Enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup()
    -- Ensure the servers above are installed
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    -- Nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Attach capabilities and keybinds in attach
    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        })
      end,
    })

    -- Can't add 'gdscript' to servers, not listed on Mason. Manually configure via lspconfig
    local gdscript_config = {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {},
    }
    require("lspconfig").gdscript.setup(gdscript_config)
  end
}
