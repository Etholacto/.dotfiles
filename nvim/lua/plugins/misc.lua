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
  { 'mbbill/undotree',
    vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" }),
  },
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
