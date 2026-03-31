{
  config,
  pkgs,
  lib,
  ...
}:
# === Niri ===
{
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
        "Mod+Shift+E".action.quit.skip-confirmation = true;
        "Mod+Shift+Backspace".action.spawn = "swaylock";
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

        # -- Windows --
        "Mod+Q".action.close-window = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+C".action.center-column = { };

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

        # -- Move windows --
        "Mod+Shift+H".action.move-column-left = { };
        "Mod+Shift+L".action.move-column-right = { };
        "Mod+Shift+J".action.move-window-down = { };
        "Mod+Shift+K".action.move-window-up = { };

        "Mod+Shift+Left".action.move-column-left = { };
        "Mod+Shift+Right".action.move-column-right = { };
        "Mod+Shift+Down".action.move-window-down = { };
        "Mod+Shift+Up".action.move-window-up = { };

        # -- Resize --
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+R".action.switch-preset-column-width = { };

        # -- Workspaces --
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+Page_Down".action.focus-workspace-down = { };
        "Mod+Page_Up".action.focus-workspace-up = { };
        "Mod+Shift+Page_Down".action.move-column-to-workspace-down = { };
        "Mod+Shift+Page_Up".action.move-column-to-workspace-up = { };

        # -- Screenshots --
        "Print".action.screenshot = { };
        "Shift+Print".action.screenshot-screen = { };
        "Ctrl+Print".action.screenshot-window = { };

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

  # === Waybar ===
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;
        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "cpu"
          "memory"
          "tray"
        ];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
          };
        };
        "niri/window" = {
          max-length = 60;
        };
        clock = {
          format = " {:%a %b %d  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}\n{essid}";
          on-click = "nm-connection-editor";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons.default = [
            ""
            ""
            ""
          ];
          on-click = "pavucontrol";
        };
        cpu = {
          format = " {usage}%";
          interval = 5;
        };
        memory = {
          format = " {used:.1f}G";
          interval = 10;
        };
        tray = {
          spacing = 8;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
      window#waybar {
        background-color: #1a1b26;
        color: #c0caf5;
        border-bottom: 2px solid #f38ba8;
      }
      .modules-left,
      .modules-right,
      .modules-center {
        padding: 0 8px;
      }
      #workspaces button {
        padding: 0 6px;
        color: #565f89;
        background: transparent;
      }
      #workspaces button.active {
        color: #f38ba8;
        font-weight: bold;
      }
      #workspaces button:hover {
        background: #24283b;
        color: #c0caf5;
      }
      #window {
        color: #7aa2f7;
        font-style: italic;
      }
      #clock {
        color: #e0af68;
        font-weight: bold;
      }
      #battery {
        color: #9ece6a;
      }
      #battery.warning {
        color: #e0af68;
      }
      #battery.critical {
        color: #f38ba8;
      }
      #network {
        color: #7dcfff;
      }
      #pulseaudio {
        color: #bb9af7;
      }
      #pulseaudio.muted {
        color: #565f89;
      }
      #cpu {
        color: #ff9e64;
      }
      #memory {
        color: #73daca;
      }
      #tray {
        color: #c0caf5;
      }
      tooltip {
        background-color: #1a1b26;
        border: 1px solid #414868;
        color: #c0caf5;
      }
    '';
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

  # === Mako ===
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1a1b26";
      text-color = "#c0caf5";
      border-color = "#f38ba8";
      border-radius = 6;
      border-size = 2;
      width = 340;
      height = 100;
      margin = "12";
      padding = "12";
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      font = "JetBrains Mono Nerd Font 12";
      max-icon-size = 48;
      "[urgency=low]" = {
        border-color = "#565f89";
        default-timeout = 3000;
      };
      "[urgency=high]" = {
        border-color = "#f38ba8";
        background-color = "#2d1b2e";
        default-timeout = 0;
      };
    };
  };

  # === Swaylock ===
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1a1b26";
      bs-hl-color = "f38ba8";
      caps-lock-bs-hl-color = "e0af68";
      caps-lock-key-hl-color = "e0af68";
      inside-color = "1a1b2600";
      inside-clear-color = "1a1b2600";
      inside-ver-color = "1a1b2600";
      inside-wrong-color = "1a1b2600";
      key-hl-color = "7aa2f7";
      layout-bg-color = "1a1b2600";
      line-uses-ring = true;
      ring-color = "414868";
      ring-clear-color = "7dcfff";
      ring-ver-color = "7aa2f7";
      ring-wrong-color = "f38ba8";
      text-color = "c0caf5";
      text-clear-color = "7dcfff";
      text-ver-color = "7aa2f7";
      text-wrong-color = "f38ba8";
      indicator-radius = 80;
      indicator-thickness = 8;
      show-failed-attempts = true;
      font = "JetBrains Mono Nerd Font";
    };
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
