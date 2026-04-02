{ inputs, ... }:
{
  imports = [
    inputs.niri-flake.homeModules.niri
    ./mime.nix
    ./gnome/gnome.nix
    ./niri
    # ./hyprland.nix
  ];

  # Disable niri-flake's config generation since we're using our own
  programs.niri.config = null;
}
