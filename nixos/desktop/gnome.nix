{
  pkgs,
  ...
}:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  # Dolphin is the file manager (home-manager/desktop/dolphin.nix). Drop
  # Nautilus entirely rather than just demoting it: both packages ship a D-Bus
  # service claiming org.freedesktop.FileManager1 -- the name "show in file
  # manager" actions resolve through -- and which one wins is decided by
  # XDG_DATA_DIRS order, not by mimeapps.list. Removing it is the only way to
  # make that deterministic.
  environment.gnome.excludePackages = with pkgs; [
    nautilus
    sushi # Nautilus's spacebar-preview extension
  ];
}
