{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.color-picker
    wmctrl
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        "touchx@neuromorph"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-to-workspace-up = [ "<Control><Super>Up" ];
      switch-to-workspace-down = [ "<Control><Super>Down" ];
      move-to-workspace-left = [ "<Control><Super><Shift>Left" ];
      move-to-workspace-right = [ "<Control><Super><Shift>Right" ];
      move-to-workspace-up = [ "<Control><Super><Shift>Up" ];
      move-to-workspace-down = [ "<Control><Super><Shift>Down" ];
    };
  };
}
