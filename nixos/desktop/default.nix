{ inputs, ... }:
{
  imports = [
    inputs.niri-flake.nixosModules.niri
    ./gnome.nix
    ./niri.nix
    # ./hyprland.nix
  ];
}
