{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/yoga-pro-9i-audio-fix.nix
  ];

  networking.hostName = "penglaptop";

  # NVIDIA specific configuration for penglaptop
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    # Pinned to the 535 branch: 595.84 (the current "stable"/"production"
    # branch) crashes reproducibly in rm_acpi_nvpcf_notify -> _nv055179rm
    # (NVPCF ACPI power-notify handler), causing full-system freezes.
    # 535.x is Ada Lovelace-compatible (RTX 4060 Mobile) and much more
    # battle-tested. Revisit once upstream fixes the NVPCF crash.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          libXcursor
          libXi
          libXinerama
          libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
  ];
}
