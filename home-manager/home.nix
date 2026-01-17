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
    spotify
    google-chrome
    atac
    zenity # display for linux lenovo vantage
    pandoc
    libreoffice-qt
    gparted # disk partition changer
    ventoy-full-qt # multi-iso disk
    nixos-generators # build nix iso from current config
    nix-search-cli # search nix packages
    qbittorrent-enhanced
    parabolic
    nodejs

    # Media editing
    krita
    gimp3-with-plugins
    darktable
    imagemagick
    pdftk
    jellyfin-ffmpeg
    video-trimmer

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
    gdmap # disk space viewer

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

  # Default apps
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Existing entries
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/zip" = [ "org.gnome.Nautilus.desktop" ];

      # Added MIME associations
      "application/pdf" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];

      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      "image/x-tga" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd-ms.dds" = [ "org.gnome.Loupe.desktop" ];
      "image/x-dds" = [ "org.gnome.Loupe.desktop" ];
      "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd.radiance" = [ "org.gnome.Loupe.desktop" ];
      "image/x-exr" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-qoi" = [ "org.gnome.Loupe.desktop" ];
      "image/qoi" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml-compressed" = [ "org.gnome.Loupe.desktop" ];
      "image/avif" = [ "org.gnome.Loupe.desktop" ];
      "image/heic" = [ "org.gnome.Loupe.desktop" ];
      "image/jxl" = [ "org.gnome.Loupe.desktop" ];

      "video/3gp" = [ "org.gnome.Totem.desktop" ];
      "video/3gpp" = [ "org.gnome.Totem.desktop" ];
      "video/3gpp2" = [ "org.gnome.Totem.desktop" ];
      "video/dv" = [ "org.gnome.Totem.desktop" ];
      "video/divx" = [ "org.gnome.Totem.desktop" ];
      "video/fli" = [ "org.gnome.Totem.desktop" ];
      "video/flv" = [ "org.gnome.Totem.desktop" ];
      "video/mp2t" = [ "org.gnome.Totem.desktop" ];
      "video/mp4" = [ "org.gnome.Totem.desktop" ];
      "video/mp4v-es" = [ "org.gnome.Totem.desktop" ];
      "video/mpeg" = [ "org.gnome.Totem.desktop" ];
      "video/mpeg-system" = [ "org.gnome.Totem.desktop" ];
      "video/msvideo" = [ "org.gnome.Totem.desktop" ];
      "video/ogg" = [ "org.gnome.Totem.desktop" ];
      "video/quicktime" = [ "org.gnome.Totem.desktop" ];
      "video/vivo" = [ "org.gnome.Totem.desktop" ];
      "video/vnd.divx" = [ "org.gnome.Totem.desktop" ];
      "video/vnd.mpegurl" = [ "org.gnome.Totem.desktop" ];
      "video/vnd.rn-realvideo" = [ "org.gnome.Totem.desktop" ];
      "video/vnd.vivo" = [ "org.gnome.Totem.desktop" ];
      "video/webm" = [ "org.gnome.Totem.desktop" ];
      "video/x-anim" = [ "org.gnome.Totem.desktop" ];
      "video/x-avi" = [ "org.gnome.Totem.desktop" ];
      "video/x-flc" = [ "org.gnome.Totem.desktop" ];
      "video/x-fli" = [ "org.gnome.Totem.desktop" ];
      "video/x-flic" = [ "org.gnome.Totem.desktop" ];
      "video/x-flv" = [ "org.gnome.Totem.desktop" ];
      "video/x-m4v" = [ "org.gnome.Totem.desktop" ];
      "video/x-matroska" = [ "org.gnome.Totem.desktop" ];
      "video/x-mjpeg" = [ "org.gnome.Totem.desktop" ];
      "video/x-mpeg" = [ "org.gnome.Totem.desktop" ];
      "video/x-mpeg2" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-asf" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-asf-plugin" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-asx" = [ "org.gnome.Totem.desktop" ];
      "video/x-msvideo" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-wm" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-wmv" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-wmx" = [ "org.gnome.Totem.desktop" ];
      "video/x-ms-wvx" = [ "org.gnome.Totem.desktop" ];
      "video/x-nsv" = [ "org.gnome.Totem.desktop" ];
      "video/x-theora" = [ "org.gnome.Totem.desktop" ];
      "video/x-theora+ogg" = [ "org.gnome.Totem.desktop" ];
      "video/x-totem-stream" = [ "org.gnome.Totem.desktop" ];
    };
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
  home.stateVersion = "25.11";
}
