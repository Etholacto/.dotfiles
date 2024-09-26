return {
   "nvim-lualine/lualine.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   opts = function()
      local kanagawa_paper = require("lualine.themes.kanagawa-paper")
      return {
         options = {
            icons_enabled = true,
            theme = kanagawa_paper,
            section_separators = { left = '', right = '' },
            component_separators = { left = "", right = "" },
            disabled_filetypes = {
               statusline = {},
               winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
               statusline = 1000,
               tabline = 1000,
               winbar = 1000,
            },
            ftm = string,
         },
         sections = {
            lualine_a = { 'mode' },
            lualine_b = { "branch" },
            lualine_c = { "diff" },
            lualine_x = { "diagnostics" },
            lualine_y = { "filetype" },
            lualine_z = { "location" },
         },
         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
         },
      }
   end,
}
