-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Detect if the system is running Windows
local is_windows = wezterm.target_triple:match("windows")

return {
	color_scheme = "Kanagawa (Gogh)",
	enable_tab_bar = false,
	font_size = 11.0,
	window_background_opacity = 1,
	window_decorations = "RESIZE",
}
