-- Paint the terminal's own background with the colorscheme's background, so the
-- leftover pixels around the character grid (kitty) blend in with nvim.
-- In kitty, also make the background more opaque while nvim is open.
-- Both are restored when nvim exits or is suspended.

local NVIM_OPACITY = 0.95 -- kitty.conf background_opacity is 0.8

local group = vim.api.nvim_create_augroup("TerminalBackgroundSync", { clear = true })

-- Needs dynamic_background_opacity, allow_remote_control and listen_on in kitty.conf
local function kitty_opacity(args, wait)
	if not (vim.env.KITTY_LISTEN_ON and vim.env.KITTY_WINDOW_ID) then
		return
	end
	local cmd = { "kitten", "@", "--to", vim.env.KITTY_LISTEN_ON, "set-background-opacity", "--match", "id:" .. vim.env.KITTY_WINDOW_ID }
	vim.list_extend(cmd, args)
	local job = vim.system(cmd)
	if wait then
		job:wait(500)
	end
end

local function set_terminal_bg()
	local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
	if bg then
		io.stdout:write(string.format("\027]11;#%06x\007", bg))
	end
end

local function reset_terminal_bg()
	io.stdout:write("\027]111\007")
end

vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_terminal_bg })

vim.api.nvim_create_autocmd({ "UIEnter", "VimResume" }, {
	group = group,
	callback = function()
		set_terminal_bg()
		kitty_opacity({ tostring(NVIM_OPACITY) })
	end,
})

vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
	group = group,
	callback = function()
		reset_terminal_bg()
		-- --toggle resets to the kitty.conf default because the current value equals NVIM_OPACITY
		kitty_opacity({ "--toggle", tostring(NVIM_OPACITY) }, true)
	end,
})
