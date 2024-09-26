return {
  {
    "j-hui/fidget.nvim",
    dependencies = { "rcarriga/nvim-notify" },
    opts = {
      window = {
        winblend = 0
      }
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "utilyre/barbecue.nvim",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = "auto",
    },
  },
  { 'mbbill/undotree',
    vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" }),
  },
  { "voldikss/vim-floaterm" },
  {
     "christoomey/vim-tmux-navigator",
     lazy = false,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },
}
