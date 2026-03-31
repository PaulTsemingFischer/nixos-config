# Home-manager config file
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
    ./terminal/aliases.nix
    ./terminal/pengl-zsh.nix
    ./desktop/default.nix
    ./desktop/mime.nix
  ];

  nixpkgs = {
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
    config = {
      allowUnfree = true;

      permittedInsecurePackages = [
        "ventoy-qt5-1.1.07"
      ];
    };
  };

  news.display = "silent";

  home = {
    username = "pengl";
    homeDirectory = "/home/pengl";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    google-chrome
    atac
    pandoc
    libreoffice-qt
    gparted # disk partition changer
    ventoy-full-qt # multi-iso disk creator
    nixos-generators # build nix iso from current config
    nix-search-cli # search nix packages
    qbittorrent-enhanced
    parabolic # video downloader
    anki # flashcards
    jflex # lexer generator
    diffutils # diff command
    audacity # audio editing
    qemu # vms
    lenovo-vantage

    # Media editing
    krita
    gimp3-with-plugins
    darktable
    imagemagick
    pdftk
    jellyfin-ffmpeg
    video-trimmer

    # Media consumption
    spotify
    spotdl
    kdePackages.dolphin # file manager
    kdePackages.qtsvg # (for dolphin previews)

    # Communication
    discord
    vencord
    vesktop
    mattermost-desktop
    slack
    zoom-us
    zapzap # (Whatsapp)

    # Coding
    git
    gh
    unstable.vscode
    jetbrains.idea-ultimate
    jetbrains-toolbox
    nixd # Nix LSP

    # C/C++
    clang-tools
    cmake
    gcc
    valgrind

    # OCaml
    opam
    ocaml
    ocamlPackages.findlib
    ocamlPackages.dune_3
    gnumake
    z3
    pkg-config
    cairo
    gtk3

    # Rocq
    rocq-core
    rocqPackages.vsrocq-language-server
    vscode-extensions.rocq-prover.vsrocq
    rocqPackages.stdlib

    # Python
    python3
    python313Packages.pillow

    # Node
    nodejs_24

    # Gaming
    prismlauncher
    lunar-client
    protonup-ng
    heroic
    steam-run

    # Remote access
    wget
    parsec-bin

    # Hardware
    (btop.override {
      cudaSupport = true; # Enable NVIDIA GPU support
    })
    bluez # Bluetooth info
    pkgs.mesa-demos # GPU testing
    pciutils # (list PCI)
    libinput # Lists keyboard ids

    #Utilities/misc system
    zip
    tree
    wezterm
    warp-terminal
    eza
    nerd-fonts.jetbrains-mono
    font-awesome
    pay-respects
    qdirstat # disk space viewer
    trashy # command line trash
    undollar # Removes dollar signs when pasted
    neofetch # system info in terminal

    # Dropbox
    maestral
    maestral-gui
    # libappindicator-gtk3
    # libdbusmenu-gtk3
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  #direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  #SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = {
      identitiesOnly = true;
    };

    matchBlocks."github.com" = {
      identityFile = "~/.ssh/id_ed25519";
    };

    matchBlocks."github.coecis.cornell.edu" = {
      identityFile = "~/.ssh/id_ed25519";
    };

    extraConfig = ''
      Include ~/.ssh/config.local
    '';
  };

  services.ssh-agent.enable = true;

  #Git
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Paul Fischer";
        email = "paultsemingfischer@gmail.com";
      };

      pull.rebase = false;

      init.defaultBranch = "main";

      core = {
        fsmonitor = true;
      };

      push = {
        autoSetupRemote = true;
      };
    };
  };

  fonts.fontconfig.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
  };

  #Proton
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
