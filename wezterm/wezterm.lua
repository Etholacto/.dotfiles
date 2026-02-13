-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.automatically_reload_config = true

wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Detect if the system is running Windows
local is_windows = wezterm.target_triple:match("windows")

config.color_scheme = "Kanagawa (Gogh)"
config.enable_tab_bar = false
config.font_size = 11.0
config.window_background_opacity = 1
config.window_decorations = "RESIZE"

if is_windows then
	config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }
end

return config
