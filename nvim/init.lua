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

local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end

-- This has to be set before initializing lazy
vim.g.mapleader = " "

require("lazy").setup("plugins", {
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
