{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
  ];
}
