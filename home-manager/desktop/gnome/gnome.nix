{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.color-picker
    gnomeExtensions.window-calls
    wmctrl
  ];
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        "touchx@neuromorph"
        "appindicatorsupport@rgcjonas.gmail.com"
        "window-calls@domandoman.xyz"
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
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.hm.gvariant.mkArray lib.hm.gvariant.type.string [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open WezTerm";
      command = "${pkgs.wezterm}/bin/wezterm";
      binding = "<Super><Shift>1";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open Ulauncher";
      command = "ulauncher-toggle";
      binding = "<Super>r";
    };
  };
}
