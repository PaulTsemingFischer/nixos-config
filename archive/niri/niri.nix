{
  config,
  pkgs,
  lib,
  ...
}:
# === Niri ===
{
  imports = [
    ./mako.nix
    ./swaylock.nix
    ./waybar.nix
  ];
  programs.niri = {
    enable = true;
    settings = {
      # ---- Input ----
      input = {
        keyboard = {
          xkb = {
            layout = "us";
          };
          repeat-delay = 250;
          repeat-rate = 50;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
          accel-speed = 0.2;
        };
        mouse = {
          accel-speed = 0.0;
        };
      };

      # ---- Layout ----
      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 0.333; }
          { proportion = 0.5; }
          { proportion = 0.667; }
          { proportion = 1.0; }
        ];
        default-column-width = {
          proportion = 0.5;
        };
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#f38ba8";
          inactive.color = "#414868";
        };
        border = {
          enable = false;
        };
      };

      # ---- Appearance ----
      prefer-no-csd = true;

      # ---- Animations ----
      animations = {
        slowdown = 1.0;
      };

      # ---- Startup ----
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
        {
          command = [
            "swayidle"
            "-w"
            "timeout"
            "300"
            "swaylock -f"
            "timeout"
            "600"
            "systemctl suspend"
            "before-sleep"
            "swaylock -f"
          ];
        }
        {
          command = [
            "gnome-keyring-daemon"
            "--start"
            "--components=secrets"
          ];
        }
      ];

      # ---- Keybindings ----
      binds = {
        # -- Session --
        "Mod+Shift+E".action.quit = { };
        "Super+Alt+L".action.spawn = "swaylock";
        "Mod+Return".action.spawn = "wezterm";
        "Mod+D".action.spawn = [
          "wofi"
          "--show"
          "run"
        ];
        "Mod+Shift+D".action.spawn = [
          "wofi"
          "--show"
          "drun"
        ];
        "Mod+Shift+P".action.power-off-monitors = { };
        "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = { };

        # -- Overview --
        "Mod+O".action.toggle-overview = { };

        # -- Windows --
        "Mod+Q".action.close-window = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        # "Mod+M".action.maximize-window-to-edges = { };
        "Mod+C".action.center-column = { };
        "Mod+Ctrl+C".action.center-visible-columns = { };
        "Mod+Ctrl+F".action.expand-column-to-available-width = { };

        # -- Floating --
        "Mod+V".action.toggle-window-floating = { };
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

        # -- Tabbed --
        "Mod+W".action.toggle-column-tabbed-display = { };

        # -- Column consume/expel --
        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = { };
        "Mod+Comma".action.consume-window-into-column = { };
        "Mod+Period".action.expel-window-from-column = { };

        # -- Focus (hjkl) --
        "Mod+H".action.focus-column-left = { };
        "Mod+L".action.focus-column-right = { };
        "Mod+J".action.focus-window-down = { };
        "Mod+K".action.focus-window-up = { };

        # -- Focus (arrows) --
        "Mod+Left".action.focus-column-left = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Down".action.focus-window-down = { };
        "Mod+Up".action.focus-window-up = { };

        # -- Move windows (Ctrl+hjkl / Ctrl+arrows) --
        "Mod+Ctrl+H".action.move-column-left = { };
        "Mod+Ctrl+L".action.move-column-right = { };
        "Mod+Ctrl+J".action.move-window-down = { };
        "Mod+Ctrl+K".action.move-window-up = { };

        "Mod+Ctrl+Left".action.move-column-left = { };
        "Mod+Ctrl+Right".action.move-column-right = { };
        "Mod+Ctrl+Down".action.move-window-down = { };
        "Mod+Ctrl+Up".action.move-window-up = { };

        # -- Move to monitor --
        "Mod+Shift+H".action.focus-monitor-left = { };
        "Mod+Shift+L".action.focus-monitor-right = { };
        "Mod+Shift+J".action.focus-monitor-down = { };
        "Mod+Shift+K".action.focus-monitor-up = { };

        "Mod+Shift+Left".action.focus-monitor-left = { };
        "Mod+Shift+Right".action.focus-monitor-right = { };
        "Mod+Shift+Down".action.focus-monitor-down = { };
        "Mod+Shift+Up".action.focus-monitor-up = { };

        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = { };

        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };

        # -- Resize --
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+Shift+R".action.switch-preset-window-height = { };
        "Mod+Ctrl+R".action.reset-window-height = { };

        # -- Workspaces --
        "Mod+U".action.focus-workspace-down = { };
        "Mod+I".action.focus-workspace-up = { };
        "Mod+Page_Down".action.focus-workspace-down = { };
        "Mod+Page_Up".action.focus-workspace-up = { };

        "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+I".action.move-column-to-workspace-up = { };
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };

        "Mod+Shift+U".action.move-workspace-down = { };
        "Mod+Shift+I".action.move-workspace-up = { };
        "Mod+Shift+Page_Down".action.move-workspace-down = { };
        "Mod+Shift+Page_Up".action.move-workspace-up = { };

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        # -- Screenshots --
        "Print".action.screenshot = { };
        "Ctrl+Print".action.screenshot-screen = { };
        "Alt+Print".action.screenshot-window = { };

        # -- Media / brightness --
        "XF86AudioRaiseVolume".action.spawn = [
          "pamixer"
          "-i"
          "5"
        ];
        "XF86AudioLowerVolume".action.spawn = [
          "pamixer"
          "-d"
          "5"
        ];
        "XF86AudioMute".action.spawn = [
          "pamixer"
          "-t"
        ];
        "XF86MonBrightnessUp".action.spawn = [
          "brightnessctl"
          "set"
          "5%+"
        ];
        "XF86MonBrightnessDown".action.spawn = [
          "brightnessctl"
          "set"
          "5%-"
        ];
      };

      # ---- Window rules ----
      window-rules = [
        {
          matches = [ { app-id = "org.gnome.Nautilus"; } ];
          open-floating = true;
        }
      ];
    };
  };

  # === Wofi ===
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 350;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 20;
      gtk_dark = true;
    };
    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 14px;
      }
      window {
        background-color: #1a1b26;
        color: #c0caf5;
        border: 2px solid #f38ba8;
        border-radius: 8px;
      }
      #input {
        background-color: #24283b;
        color: #c0caf5;
        border: 1px solid #414868;
        border-radius: 4px;
        padding: 8px;
        margin: 8px;
      }
      #input:focus {
        border-color: #7aa2f7;
      }
      #inner-box {
        background-color: transparent;
      }
      #outer-box {
        padding: 8px;
      }
      #entry {
        padding: 6px 10px;
        border-radius: 4px;
      }
      #entry:selected {
        background-color: #24283b;
        color: #7aa2f7;
      }
      #text:selected {
        color: #7aa2f7;
      }
    '';
  };

  # === Extra packages ===
  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    swayidle
    pavucontrol
    networkmanagerapplet
  ];
}
