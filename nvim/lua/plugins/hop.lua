return {
  'smoka7/hop.nvim',
  version = '*', -- optional but strongly recommended
      opts = {
      keys = 'etovxqpdygfblzhckisuran'
    },

  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require 'hop'.setup { vim.keymap.set("n", "hc", ":HopChar1<CR>"),
      vim.keymap.set("n", "hw", ":HopWord<CR>"),
      vim.keymap.set("n", "hp", ":HopPattern<CR>"),
      vim.keymap.set("n", "hl", ":HopLine<CR>") }
  end
}
