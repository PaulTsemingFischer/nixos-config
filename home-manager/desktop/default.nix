{ inputs, ... }:
{
  imports = [
    inputs.niri-flake.homeModules.niri
    ./gnome.nix
    ./niri.nix
    # ./hyprland.nix
  ];
}
