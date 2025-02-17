--Set Global vars
_G.packagePath = vim.fn.stdpath('data') .. '/mason/packages'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

--Listen to the Port set by godot
local gdproject = io.open(vim.fn.getcwd() .. '/project.godot', 'r')
if gdproject then
   io.close(gdproject)
   vim.fn.serverstart './godothost'
end

--Changes all GLSL type files to correct filetype
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.vert", "*.frag", "*.comp", "*.rchit", "*.rmiss", "*.rahit"},
    command = "set filetype=glsl"
})

-- This has to be set before initializing lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require("lazy").setup({
	spec = {
		{import = "plugins"},
		{import = "plugins.lsp"},
		{import = "plugins.git"},
		{import = "plugins.lang"},
	},
   install = {
      colorscheme = { "kanagawa" },
   },
   checker = {
      enable = true,
      notify = false,
   },
   change_detection = {
      enabled = true,
      notify = false,
   },
})

-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")
