-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on("gui-startup", function ()
   local tab,pane,window = wezterm.mux.spawn_window{}
   window:gui_window():maximize()
end)

return{
   color_scheme = 'Kanagawa (Gogh)',
   enable_tab_bar = false,
   font_size = 11.0,
   font = wezterm.font('MesloLGS NF'),
   window_background_opacity = 1.0,
   window_decorations = 'RESIZE',
}

