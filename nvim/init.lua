--Set Global vars
_G.packagePath = vim.fn.stdpath("data") .. "/mason/packages"

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
local gdproject = io.open(vim.fn.getcwd() .. "/project.godot", "r")
if gdproject then
	io.close(gdproject)
	vim.fn.serverstart("./godothost")
end

--Changes all GLSL type files to correct filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.vert", "*.frag", "*.comp", "*.rchit", "*.rmiss", "*.rahit" },
	command = "set filetype=glsl",
})

-- This has to be set before initializing lazy
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local lang_specs = {}
for name, ftype in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/lang") do
	if ftype == "file" and name:match("%.lua$") then
		local mod = require("lang." .. name:gsub("%.lua$", ""))
		if mod.plugins then
			vim.list_extend(lang_specs, mod.plugins)
		end
	end
end

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.code" },
		{ import = "plugins.git" },
		lang_specs,
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
	rocks = {
		enable = false,
		hererocks = false,
	},
})

if vim.fn.has("win32") == 1 then
	vim.opt.shell = "pwsh"
	vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
	vim.opt.shellpipe = "| Out-File -Encoding UTF8 %s"
	vim.opt.shellredir = "| Out-File -Encoding UTF8 %s"
end

-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")
