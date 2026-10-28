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
    ./seafile.nix
  ];

  networking.hostName = "penglpc";

  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB, matches RAM
    }
  ];

  # Windows dual-boot: chainload from this machine's own Windows ESP
  # (nvme0n1p1, confirmed to hold EFI/Microsoft/Boot/bootmgfw.efi).
  boot.loader.grub.extraEntries = ''
    menuentry "Windows" {
      insmod part_gpt
      insmod fat
      insmod chain
      search --no-floppy --fs-uuid --set=root DADA-D4B7
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';

  # NVIDIA specific configuration for penglpc (single discrete GPU, no prime/offload)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    # Keeps the GPU initialized from early boot via nvidia-persistenced.service.
    # Without this, services that probe for CUDA at startup (e.g. ollama) can
    # race the driver during boot, silently fall back to CPU, and stay that
    # way until restarted -- see systemd.services.ollama.after in
    # nixos/configuration.nix, which depends on this being enabled.
    nvidiaPersistenced = true;
    # Enables the nvidia-suspend/-resume/-hibernate systemd services that
    # save/restore VRAM state, in case suspend is ever re-enabled.
    powerManagement.enable = true;
  };

  # Suspend/resume is broken on this machine at the firmware/hardware level
  # (reproduces identically on Windows: screen stays black, never wakes,
  # requires a hard power-cycle) -- confirmed 2026-09-11 even with the
  # NVIDIA powerManagement fix above in place. Masking these targets stops
  # anything (idle timeout, lid, explicit suspend) from ever suspending it.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

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
