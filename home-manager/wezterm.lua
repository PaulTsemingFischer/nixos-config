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
config.hide_tab_bar_if_only_one_tab = false

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
  { key = 'J', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'K', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  
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
  {
    key = 'a',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
        local dims = pane:get_dimensions()
        local lines = {}
        
        for i = 0, dims.scrollback_rows - 1 do
            local line = pane:get_text_from_region(
                0,
                dims.scrollback_top + i,
                dims.cols - 1,
                dims.scrollback_top + i
            )
            
            if line and line ~= '' then
                -- Trim trailing whitespace
                line = line:match('^(.-)%s*$')
                -- Remove ANSI color codes
                line = line:gsub('\27%[[%d;]*[A-Za-z]', '')
                
                -- Check if this looks like a prompt line (contains pengl and ends with directory pattern)
                local is_prompt = line:match('pengl') and line:match('[\u{E0B0}]')
                
                if is_prompt then
                    -- For prompt lines, do aggressive filtering
                    -- Remove everything before the last > (which we'll create)
                    -- Find the last occurrence of arrow (U+E0B0)
                    local last_pos = nil
                    local pos = 1
                    while true do
                        local found = line:find('[\u{E0B0}]', pos)
                        if not found then break end
                        last_pos = found
                        pos = found + 1
                    end
                    
                    if last_pos then
                        -- Replace the last arrow with > and remove everything before it except directory
                        local after_arrow = line:sub(last_pos + 2) -- +2 to skip the UTF-8 bytes
                        -- Try to extract just the directory part before the arrow
                        local dir = line:match('/[^'..string.char(0xEE, 0x82, 0xB0)..']*') or ''
                        line = dir .. '>' .. after_arrow
                    end
                    
                    -- Remove "pengl ~ " prefix
                    line = line:gsub('pengl%s*~%s*', '')
                else
                    -- For non-prompt lines (like ls output), only remove Nerd Font icons
                    -- but preserve the text
                    local result = {}
                    for char in line:gmatch('[\u{0000}-\u{DFFF}\u{E000}-\u{F8FF}\u{10000}-\u{10FFFF}]') do
                        if not char:match('[\u{E000}-\u{F8FF}]') then
                            table.insert(result, char)
                        end
                    end
                    line = table.concat(result)
                end
                
                -- Final cleanup for all lines
                line = line:gsub('%s+', ' ') -- Collapse multiple spaces
                line = line:gsub('%s+>', '>') -- Remove space before >
                line = line:match('^%s*(.-)%s*$') -- Trim
                
                if line and line ~= '' then
                    table.insert(lines, line)
                end
            end
        end
        
        local txt = table.concat(lines, '\n')
        if txt and #txt > 0 then
            window:copy_to_clipboard(txt)
        else
            window:toast_notification('WezTerm', 'Copy failed', nil, 1000)
        end
    end),
},
  

  
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
