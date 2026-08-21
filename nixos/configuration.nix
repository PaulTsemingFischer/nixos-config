# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    ./desktop/default.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      extraOptions = ''
        warn-dirty = false
      '';
    };

  # Systemd boot
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Grub boot
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };

    timeout = 30; # time until autoload first profile

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      #      theme = "/home/pengl/Documents/nix-config/themes/grub/CelesteGRUB1440p";
      useOSProber = false;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod chain
          search --no-floppy --fs-uuid --set=root 2CC2-1CB5
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        menuentry "UEFI Firmware Settings" {
          fwsetup
        }
      '';
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow passwordless sudo for wheel
  security.sudo.wheelNeedsPassword = false;
  # Allow passwordless sudo for nixos-rebuil
  # security.sudo.extraRules = [
  #   {
  #     users = [ "pengl" ];
  #     commands = [
  #       {
  #         command = "/run/current-system/sw/bin/nixos-rebuild";
  #         options = [ "NOPASSWD" ];
  #       }
  #     ];
  #   }
  # ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # The merged /run/opengl-driver bundle (mesa + nvidia-x11) has been missing
  # the vendor-neutral libglvnd EGL dispatcher, breaking any app that inits
  # OpenGL via EGL (e.g. wezterm's default front_end) with "libEGL.so.1: cannot
  # open shared object file" even though the vendor libEGL_mesa/libEGL_nvidia
  # libs are present. Force it into the bundle explicitly.
  hardware.graphics.extraPackages = [ pkgs.libglvnd ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  wget
    git
    mangohud
    nvtopPackages.full
    keyd
    # Audio tools moved to yoga-pro-9i-audio.nix module
  ];

  # Virtualization

  virtualisation.docker.enable = true;

  # Enable VirtualBox host (installs GUI + kernel modules)
  virtualisation.virtualbox.host.enable = true;

  # Optional: Oracle Extension Pack (USB2/3 etc.)
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Let your user use VirtualBox
  users.extraGroups.vboxusers.members = [ "pengl" ];

  users.users = {
    pengl = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "chbs";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # Firewalls

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 9000 ];

  #Needed for windsurf
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [ ];

  #Keyboard
  services.keyd.enable = true;

  services.keyd.keyboards = {
    bluetooth = {
      ids = [ "*" ]; # Samsers keyboard
      settings = {
        main = {
          capslock = "end";
        };
        shift = {
          capslock = "home";
        };
        alt = {
          capslock = "pageup";
        };
        "alt+shift" = {
          capslock = "pagedown";
        };
        control = {
          capslock = "capslock";
        };
      };
    };
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    # Declaratively pull the models opencode is configured to use
    # (home-manager/opencode.nix) so a fresh rebuild reproduces the whole
    # local-model setup with no manual `ollama pull` steps. Selected from a
    # 10-model benchmark (~/opencode-benchmark/RESULTS.md, 2026-08-20) --
    # see home-manager/opencode.nix for per-model strengths/weaknesses.
    # devstral:24b and command-r7b:7b were also benchmarked but didn't make
    # the cut (devstral too slow on this GPU's 8GB VRAM, command-r7b weak on
    # both tool-calling and chat quality) -- syncModels below removes them.
    loadModels = [
      "gpt-oss:20b"
      "llama3.1:8b"
      "qwen3:8b"
      "mistral-nemo:12b"
      "qwen2.5-coder:7b"
      "qwen3-coder:30b"
      "phi4:14b"
      "deepseek-r1:8b"
    ];
    # Remove any models installed outside of loadModels so the machine
    # state always matches what's declared here.
    syncModels = true;
  };

  # Actual budget
  # services.actual = {
  #   enable = true;
  #   settings = {
  #     port = 5006;
  #     hostname = "0.0.0.0";
  #   };
  # };

  services.tailscale.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
