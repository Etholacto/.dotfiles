local opt = vim.opt -- for conciseness

opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
opt.scrolloff = 10 -- minimum number of lines to keep above and below the cursor

opt.tabstop = 3 -- 3 spaces for tabs (prettier default)
opt.shiftwidth = 3 -- 3 spaces for indent width
opt.softtabstop = 3 -- 3 number of spaces tab counts for while editing
opt.expandtab = true -- expand tab to spaces

opt.autoindent = true -- copy indent from current line when starting new one
opt.wrap = false -- disable line wrapping

opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true -- highlight the current cursor line

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

opt.clipboard:append("unnamedplus") -- use system clipboard as default register

opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.swapfile = false -- turns off swapfiles for buffers
opt.undofile = true -- automatically saves undo history to an undo file
