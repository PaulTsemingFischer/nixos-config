{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "penglwsl";

  # Enable WSL integration
  wsl.enable = true;
  wsl.defaultUser = "pengl";

  # WSL-specific settings
  wsl.docker-desktop.enable = true;

  # Disable bootloader for WSL (prevents multiple definitions error)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;

  # Add WSL-specific packages if needed
  environment.systemPackages = with pkgs; [
    wslu # WSL utilities
    wget
  ];
}
