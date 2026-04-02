{ wallpaper }:
''
  spawn-at-startup "bash" "-c" "wl-paste --watch cliphist store &"
  spawn-at-startup "noctalia-shell"
  spawn-at-startup "bash" "-c" "swww-daemon && sleep 1 && swww img '${wallpaper}'"
  spawn-at-startup "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
''
