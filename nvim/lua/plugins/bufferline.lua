return {
   "akinsho/bufferline.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   version = "*",
   opts = {
      options = {
         mode = "buffer",
         diagnostics = "nvim_lsp",
         buffer_close_icon = '',
         modified_icon = '●',
         close_icon = '',
         left_trunc_marker = '',
         right_trunc_marker = '',
         indicator = {
            icon = "|",
            style = 'icon',
         },
         show_tab_indicators = true,
         color_icons = true,
         max_name_length = 18,
         max_prefix_length = 15,
         tab_size = 18,
         get_element_icon = function(element)
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
         end,
         hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
         },
         diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and "" or ""
            return "" .. icon .. " " .. count .. ""
         end,
      },
   },
   config = function()
      local bufferline = require('bufferline')
      bufferline.setup({
         options = {
            style_preset = {
               bufferline.style_preset.no_bold,
               bufferline.style_preset.no_italic
            },
         },
         highlights = {
            fill = {
               bg = "#1f1f28"
            },
            buffer_selected = {
               bg = "#363646",
            },
            indicator_selected = {
               fg = "#717c7c",
               bg = "#363646",
            },
            close_button_selected = {
               bg = '#363646'
            },
            modified_selected = {
               bg = "#363646"
            },
            separator_selected = {
               bg = "#363646"
            },
            diagnostic_selected = {
               bg = "#363646"
            },
            trunc_marker = {
               bg = "#1f1f28"
            }
         }
      })
   end
}
