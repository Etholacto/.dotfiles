return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  config = function()
    local scrollbar = require("scrollbar")
    local colors = require("kanagawa.colors").setup()
    scrollbar.setup({
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,              -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
      max_lines = false,         -- disables if no. of lines in buffer exceeds this
      hide_if_all_visible = false, -- Hides everything if all lines are visible
      throttle_ms = 100,
      handle = {
        ext = " ",
        blend = 30,                  -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
        color = colors.bg_highlight,
        color_nr = nil,              -- cterm
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
      },
      marks = {
        Search = { color = colors.surimiOrange },
        Error = { color = colors.samuraiRed },
        Warn = { color = colors.roninYellow },
        Info = { color = colors.waveAqua1 },
        Hint = { color = colors.dragonBlue },
        Misc = { color = colors.oniViolet },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        handle = true,
        search = false,  -- Requires hlslens
        ale = false,     -- Requires ALE
      },
    })
  end,
}
