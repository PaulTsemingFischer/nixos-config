{
  pkgs,
  ...
}:
{
  # Enable niri as a wayland compositor session
  programs.niri.enable = true;

  # Wayland session support
  services.displayManager.sessionPackages = [ pkgs.niri ];

  # Required for screen locking, polkit agents, portals
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome # kept for GNOME session compatibility
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    grim # screenshots
    slurp # region selection for screenshots
    brightnessctl # backlight control
    pamixer # pulseaudio/pipewire volume control via CLI
  ];
}
