return {
   'kristijanhusak/vim-dadbod-ui',
   dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'psql', }, lazy = true },
   },
   cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
   },
   keys = {
      {"<leader>td", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI"}
   },
   init = function()
      --Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_show_database_icon = true
   end,
}
