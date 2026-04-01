# https://github.com/maximmaxim345/yoga_pro_9i_gen9_linux
{ config, pkgs, ... }:

let
  speaker-script = pkgs.writeShellScript "2pa-byps" ''
    export TERM=linux

    ${pkgs.kmod}/bin/modprobe i2c-dev

    laptop_model=$(</sys/class/dmi/id/product_name)
    echo "Laptop model: $laptop_model"

    # Function to find the correct I2C bus
    find_i2c_bus() {
        local adapter_description="Synopsys DesignWare I2C adapter"
        local dw_count=$(${pkgs.i2c-tools}/bin/i2cdetect -l | grep -c "$adapter_description")

        # Use 2nd adapter for 16IAH10 (Gen 10), 3rd for others
        local bus_index=3
        [[ "$laptop_model" == "83L0" ]] && bus_index=2

        if [ "$dw_count" -lt "$bus_index" ]; then
            echo "Error: Less than $bus_index DesignWare I2C adapters found." >&2
            return 1
        fi
        local bus_number=$(${pkgs.i2c-tools}/bin/i2cdetect -l | grep "$adapter_description" | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.gnused}/bin/sed 's/i2c-//' | ${pkgs.gnused}/bin/sed -n "''${bus_index}p")
        echo "$bus_number"
    }
    i2c_bus=$(find_i2c_bus)
    if [ -z "$i2c_bus" ]; then
        echo "Error: Could not find the DesignWare I2C bus for the audio IC." >&2
        exit 1
    fi
    echo "Using I2C bus: $i2c_bus"

    # if [[ "$laptop_model" == "83BY" ]]; then
    #     i2c_addr=(0x39 0x38 0x3d 0x3b)
    # elif [[ "$laptop_model" == "83DN" ]]; then # Added by pengl
    # i2c_addr=(0x3f 0x38 0x3d 0x3e)
    i2c_addr=(0x3f 0x3e 0x38)
    # else
    #     i2c_addr=(0x3f 0x38)
    # fi

    count=0
    for value in "''${i2c_addr[@]}"; do
        val=$((count % 2))
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x7f 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x01 0x01
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x0e 0xc4
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x0f 0x40
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x5c 0xd9
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x60 0x10
        if [ $val -eq 0 ]; then
            ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x0a 0x1e
        else
            ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x0a 0x2e
        fi
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x0d 0x01
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x16 0x40
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x00 0x01
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x17 0xc8
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x00 0x04
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x30 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x31 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x32 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x33 0x01

        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x00 0x08
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x18 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x19 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x1a 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x1b 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x28 0x40
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x29 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x2a 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x2b 0x00

        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x00 0x0a
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x48 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x49 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x4a 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x4b 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x58 0x40
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x59 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x5a 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x5b 0x00

        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
        ${pkgs.i2c-tools}/bin/i2cset -f -y "$i2c_bus" "$value" 0x02 0x00
        count=$((count + 1))
    done

    echo "Speaker initialization complete"
  '';
in
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
      "alsa-restore.service"
      "pipewire.service"
    ];
    requires = [ "sound.target" ];
    wantedBy = [
      "multi-user.target"
    ];

    serviceConfig = {
      User = "root";
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = [
        "${pkgs.coreutils}/bin/sleep 3"
        "${pkgs.bash}/bin/bash -c '${pkgs.alsa-utils}/bin/amixer -c 0 sset Master mute || true'"
      ];
      ExecStart = speaker-script;
      ExecStartPost = "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 10); do ${pkgs.alsa-utils}/bin/amixer -c 0 cset numid=3 on && break || sleep 1; done'";
    };
  };

  # Also run after suspend/resume
  systemd.services.turn-on-speakers-resume = {
    description = "Turn on speakers after resume";
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [ "sleep.target" ];

    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = speaker-script;
      ExecStartPost = "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 10); do ${pkgs.alsa-utils}/bin/amixer -c 0 cset numid=3 on && break || sleep 1; done'";
    };
  };
}
