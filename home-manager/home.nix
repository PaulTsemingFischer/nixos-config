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
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./scripts/aliases.nix
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
    spotify
    google-chrome

    libinput # Lists keyboard ids
    wget

    zip
    video-trimmer

    # Media editing
    krita
    gimp3-with-plugins
    darktable
    imagemagick
    pdftk

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
    vscode
    jetbrains.idea-ultimate
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

    # Python
    python3

    # Gaming
    prismlauncher
    lunar-client
    protonup
    heroic
    steam-run

    # System
    (btop.override {
      cudaSupport = true; # Enable NVIDIA GPU support
    })
    bluez # Bluetooth info
    pkgs.mesa-demos # GPU testing
    pciutils # lspci
    parsec-bin

    tree
    wezterm
    warp-terminal
    eza
    nerd-fonts.jetbrains-mono
    font-awesome
    thefuck

    # Dropbox
    maestral
    maestral-gui
    # libappindicator-gtk3
    # libdbusmenu-gtk3

    #Gnome
    gnome-tweaks # Used for disabling middle mouse paste on trackpads
    # gnomeExtensions.touch-x #OSK
    gnomeExtensions.appindicator # Needed for Dropbox
    gnomeExtensions.color-picker
    wmctrl # full screen stuff
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

    "org/gnome/desktop/wm/keybindings" = {
      # Unbind the default Ctrl+Alt+Arrow workspace switching keys
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-to-workspace-up = [ "<Control><Super>Up" ]; # if applicable
      switch-to-workspace-down = [ "<Control><Super>Down" ]; # if applicable

      # Set move window to workspace keys to Ctrl + Super + Shift + Arrow
      move-to-workspace-left = [ "<Control><Super><Shift>Left" ];
      move-to-workspace-right = [ "<Control><Super><Shift>Right" ];
      move-to-workspace-up = [ "<Control><Super><Shift>Up" ]; # if applicable
      move-to-workspace-down = [ "<Control><Super><Shift>Down" ]; # if applicable
    };

    # "org/gnome/desktop/a11y/applications" = {
    #   screen-keyboard-enabled = true;
    # };
  };

  #direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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

    extraConfig = {
      init.defaultBranch = "main";
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
  home.stateVersion = "25.05";
}
