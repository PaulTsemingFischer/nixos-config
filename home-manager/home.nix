# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./aliases.nix
    ./pengl-zsh.nix
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

  news.display = "silent";

  home = {
    username = "pengl";
    homeDirectory = "/home/pengl";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    vencord
    spotify
    google-chrome
    parsec-bin
    libinput #Lists keyboard ids

    nixd

    #Communication
    discord
    vesktop
    mattermost-desktop
    zoom-us
    zapzap # (Whatsapp)

    #Coding
    git
    gh
    vscode

    #C++
    clang-tools
    cmake

    #OCaml
    opam
    ocaml
    ocamlPackages.findlib
    ocamlPackages.dune_3
    gcc
    gnumake

    #Python
    python313
    python313Packages.pip
    python313Packages.pyyaml
    python313Packages.pillow
    python313Packages.shortuuid
    # nix-shell -p python3Packages.pyyaml python3Packages.pillow python3Packages.shortuuid

    #Gaming
    prismlauncher
    lunar-client
    protonup
    heroic
    steam-run

    #System
    (btop.override {
      cudaSupport = true; # Enable NVIDIA GPU support
    })
    pkgs.mesa-demos #GPU testing
    pciutils #lspci

    # nvtopPackages.v3d
    tree
    wezterm
    warp-terminal
    eza
    nerd-fonts.jetbrains-mono
    font-awesome
    thefuck

    #Dropbox
    dropbox
    libappindicator-gtk3
    libdbusmenu-gtk3

    #Gnome
    gnomeExtensions.touch-x #OSK
    gnomeExtensions.appindicator #Needed for Dropbox
    wmctrl #full screen stuff
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  #Gnome
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        "touchx@neuromorph"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
  };

  #Wezterm
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  #SSH
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes

      Host github.coecis.cornell.edu
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    '';
  };
  services.ssh-agent.enable = true;

  #Git
  programs.git = {
    enable = true;
    userName = "Paul Fischer";
    userEmail = "paultsemingfischer@gmail.com";
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
  home.stateVersion = "25.05";
}
