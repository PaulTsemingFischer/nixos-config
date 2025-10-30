{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Penglwsl-specific home-manager configuration

  home.packages = with pkgs; [
  ];
}
