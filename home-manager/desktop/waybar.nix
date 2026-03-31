{
  config,
  pkgs,
  lib,
  ...
}:
{
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
}
