# WSL hardware configuration
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # NixOS-WSL handles most hardware configuration automatically
  # Just set the host platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
