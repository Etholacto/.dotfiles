return {
  {
    -- Quick changes to delimiter pairs
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    opts = {}
  },
  {
    --Automatic pairing of delimiters
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      }
    }
  },
  {
    -- Quick commenting of code
    'tpope/vim-commentary',
    event = 'VeryLazy',
  },
  {
    -- Automatic indentation of lines
    "lukas-reineke/indent-blankline.nvim",
    event = 'BufRead',
    config = function ()
      require("ibl").setup()
    end
  },
  {
    -- More functionality for connection between nvim and godot
    "habamax/vim-godot",
    event = "VimEnter"
  },
  {
    -- Changes background to match colour (Hex, names var, etc.)
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    -- Highlights todo sections
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
