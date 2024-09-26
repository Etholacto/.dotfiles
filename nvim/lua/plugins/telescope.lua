return {
   "nvim-telescope/telescope.nvim",
   branch = "0.1.x",
   dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      {
         "nvim-telescope/telescope-fzf-native.nvim",
         build = 'make',
      },
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
   },
   config = function()
      local telescope = require("telescope")

      telescope.setup({
         defaults = {
            layout_strategy = "flex",
            layout_config = {
               vertical = {
                  prompt_position = "top",
                  mirror = true,
               },
               horizontal = {
                  prompt_position = "top",
                  mirror = false,
               },
            },
            sorting_strategy = "ascending",
            path_display = { "truncate " },
            vimgrep_arguments = {
               'rg',
               '--color=never',
               '--no-heading',
               '--with-filename',
               '--line-number',
               '--column',
               '--smart-case',
               '--hidden',
            },
            file_ignore_patterns = {},
            prompt_prefix = '> ',
            color_devicons = true,
            use_less = true,
            set_env = { ['COLORTERM'] = 'truecolor' },
            extensions = {
               file_browser = {
                  hijack_netrw = true,
                  hidden = true,
                  find_command = {
                     "rg",
                     "--files",
                     "--hidden",
                     "--glob=!**/.git/*",
                     "--glob=!**/.idea/*",
                     "--glob=!**/.vscode/*",
                     "--glob=!**/build/*",
                     "--glob=!**/dist/*",
                     "--glob=!**/yarn.lock",
                     "--glob=!**/package-lock.json",
                  }
               },
               fzf = {
                  fuzzy = true,
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = "smart_case",
               },
            },
         },
      })

      telescope.load_extension('file_browser')
      telescope.load_extension('fzf')

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files" })
      keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
      keymap.set('n', '<leader>fg', "<cmd>Telescope live_grep<cr>", { desc = "Live grep in file" })
      keymap.set(
         "n",
         "<leader>fb",
         ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
         { desc = "File browser in current buffer" },
         { noremap = true }
      )
   end,
}
