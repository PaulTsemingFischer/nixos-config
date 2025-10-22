local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = 'Tokyo Night'

-- Tab bar colors
config.colors = config.colors or {}
config.colors.tab_bar = {
	background = "#a43b58", -- Don't think this does anything
	active_tab = {
		bg_color = "#1a1b26",
		fg_color = "#f38ba8",
	},
	inactive_tab = {
		bg_color = "#343b58",
		fg_color = "#b0b0b0",
	},
}

-- Font configuration
config.font = wezterm.font('JetBrains Mono Nerd Font', { weight = 'Regular' })
config.font_size = 12.0

-- Window configuration
config.window_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.scrollback_lines = 10000

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

-- Cursor
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 500

-- Key bindings
config.keys = {
  -- Split panes
  { key = 'j', mods = 'CTRL|ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'k', mods = 'CTRL|ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'CTRL|ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'l', mods = 'CTRL|ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  
  -- Navigate between panes
  { key = 'H', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'L', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'J', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'K', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  
  -- Resize panes
  { key = 'LeftArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  
  -- Tab management
  { key = 't', mods = 'CTRL', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'w', mods = "CTRL", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
  { key = 'q', mods = 'CTRL', action = wezterm.action.QuitApplication },
  { key = 'n', mods = 'CTRL', action = wezterm.action.SpawnWindow },
  { key = 'n', mods = 'ALT', action = wezterm.action_callback(function(win, pane) local tab, window = pane:move_to_new_window() end)},
  { key = '1', mods = 'CTRL', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'CTRL', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'CTRL', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'CTRL', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'CTRL', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'CTRL', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'CTRL', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'CTRL', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'CTRL', action = wezterm.action.ActivateTab(8) },
  
  -- Text
  { key = 'c', mods = 'ALT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'R', mods = 'CTRL|SHIFT', action = wezterm.action.SendKey{ key = 't', mods = 'CTRL' } }, -- Fix word
	{ key = 'Backspace', mods = "CTRL", action = wezterm.action.SendKey{ key = "w", mods = "CTRL" } }, -- Delete word backward
  { key = 'Delete', mods = 'CTRL', action = wezterm.action.SendKey{ key = 'd', mods = 'ALT' } }, -- Delete word forward

  
  -- Zoom
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },

  -- Misc
  -- { key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action.SendKey{ key = 'c', mods = 'CTRL' } }, -- Send SigInt
  
}

-- Mouse bindings  { key = 'T', mods = 'CTRL|SHIFT', action = wezterm.action.SendKey{ key = 't', mods = 'CTRL' } },
config.mouse_bindings = {
  -- Right-click paste
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- Performance
config.max_fps = 60
config.animation_fps = 1

-- Shell
config.default_prog = { 'zsh' }

-- Gnome fix
config.enable_wayland = false 

return config
