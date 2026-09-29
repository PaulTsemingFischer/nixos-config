{ pkgs, ... }:
{
  # Kvantum-themes Qt apps (Dolphin, qBittorrent, etc.) so they don't look out
  # of place on GNOME. Dolphin itself needs an extra wrapper to actually find
  # this plugin — see ./dolphin.nix.
  qt = {
    enable = true;
    style.name = "kvantum";

    kvantum = {
      enable = true;
      themes = [ pkgs.orchis-kvantum ];
      settings.General.theme = "Orchis-solid";
    };
  };
}
