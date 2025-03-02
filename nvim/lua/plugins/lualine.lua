return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		-- Color table for highlights
		-- stylua: ignore
		local colors = {
			bg      = '#1F1F28',
			fg      = '#DCD7BA',
			add     = '#76946A',
			change  = '#FF9E3B',
			delete  = '#C34043',
			warning = '#DCA561',
			error   = '#E82424',
			hint    = '#658594',
			magenta = '#957FB8',
			blue    = '#7E9CD8',
		}

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = {
					-- We are going to use lualine_c an lualine_x as left and
					-- right section. Both are highlighted by c theme .  So we
					-- are just setting default looks o statusline
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left({
			-- mode component
			function()
				local modes = {
					n = "Normal",
					i = "Insert",
					v = "Visual",
					[""] = "VisualBlock",
					V = "VisualLine",
					c = "Command",
					no = "OperatorPending",
					s = "Select",
					S = "SelectLine",
					[""] = "SelectBlock",
					ic = "InsertCompletion",
					R = "Replace",
					Rv = "VirtualReplace",
					cv = "Ex",
					ce = "Ex",
					r = "Prompt",
					rm = "More",
					["r?"] = "Confirm",
					["!"] = "Shell",
					t = "Terminal",
				}
				return " " .. modes[vim.fn.mode()]
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.delete,
					i = colors.add,
					v = colors.blue,
					[""] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.delete,
					s = colors.warning,
					S = colors.warning,
					[""] = colors.warning,
					ic = colors.change,
					R = colors.error,
					Rv = colors.error,
					cv = colors.delete,
					ce = colors.delete,
					r = colors.hint,
					rm = colors.hint,
					["r?"] = colors.hint,
					["!"] = colors.delete,
					t = colors.delete,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { left = 1, right = 1.75 },
		})

		ins_left({
			"branch",
			icon = "",
			color = { fg = colors.blue },
		})

		ins_left({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = "+", modified = "~", removed = "-" },
			diff_color = {
				added = { fg = colors.add },
				modified = { fg = colors.change },
				removed = { fg = colors.delete },
			},
			cond = conditions.hide_in_width,
		})

		ins_right({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				error = { fg = colors.error },
				warn = { fg = colors.warning },
				info = { fg = colors.info },
			},
		})

		ins_right({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = " :",
			color = { fg = colors.magenta },
		})

		ins_right({ "location" })

		-- Now don't forget to initialize lualine
		lualine.setup(config)
	end,
}
