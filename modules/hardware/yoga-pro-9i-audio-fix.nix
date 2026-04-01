# https://github.com/maximmaxim345/yoga_pro_9i_gen9_linux
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    util-linux
    kmod
    i2c-tools
    alsa-utils
  ];

  boot.kernelModules = [ "i2c-dev" ];

  # Enable firmware
  hardware.enableRedistributableFirmware = true;

  systemd.services.turn-on-speakers = {
    description = "Turn on speakers using i2c configuration";
    after = [
      "sound.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "multi-user.target"
      "sleep.target"
    ];

    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c \"${./2pa-byps.sh} | ${pkgs.util-linux}/bin/logger\"";
    };
  };
}
