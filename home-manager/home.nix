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
    # ./launcher/ulauncher.nix
    ./desktop/default.nix
    ./opencode.nix
    ./pengltab-dashboard.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.claude-desktop.overlays.default
    ];
    config = {
      allowUnfree = true;

      permittedInsecurePackages = [
        "ventoy-qt5-1.1.12"
        "libsoup-2.74.3"
        "pnpm-10.29.2"
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
    # ventoy-full-qt # multi-iso disk creator
    nixos-generators # build nix iso from current config
    nix-search-cli # search nix packages
    qbittorrent-enhanced
    parabolic # video downloader
    anki # flashcards
    diffutils # diff command
    audacity # audio editing
    qemu # vms
    lenovo-vantage
    clipboard-jh
    graphviz
    skim # file fuzzy finder
    ollama
    todoist
    opencode
    claude-code
    claude-monitor
    claude-desktop

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
    # kdePackages.dolphin # file manager
    # kdePackages.qtsvg # (for dolphin previews)

    # Communication
    discord
    vencord
    vesktop
    mattermost-desktop
    slack
    zoom-us
    zapzap # (Whatsapp)
    beeper

    # Coding
    git
    sublime-merge # git gui
    diff-so-fancy # better git diffs in terminal
    gh
    unstable.vscode
    micro # cli text editor
    jetbrains.idea
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
    pipx

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
    rustdesk-flutter

    # Hardware
    (btop.override {
      cudaSupport = true; # Enable NVIDIA GPU support
    })
    bluez # Bluetooth info
    (lib.lowPrio pkgs.mesa-demos) # GPU testing
    pciutils # (list PCI)
    libinput # Lists keyboard ids

    #Utilities/misc system
    zip
    tree
    warp-terminal
    wezterm # Terminal
    eza # Smart ls replacement
    ulauncher
    nerd-fonts.jetbrains-mono
    font-awesome
    pay-respects
    qdirstat # disk space viewer
    trashy # command line trash
    undollar # Removes dollar signs when pasted
    hyfetch # system info in terminal

    # Dropbox
    maestral
    maestral-gui
    seafile-client
    gtk3 # (for seafile) provides org.gtk.Settings.FileChooser schema
    gsettings-desktop-schemas # (for seafile)
    libappindicator-gtk3
    libdbusmenu-gtk3

    # Goldman Sachs
    # citrix_workspace
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Launch the Seafile tray applet on login on every machine that has the seafile-client package.
  # Exec runs a wrapper (not the bare binary) because seafile-applet's native GTK3
  # folder-chooser dialog needs gtk3's org.gtk.Settings.FileChooser schema on
  # XDG_DATA_DIRS -- missing schema = fatal GLib abort, crashing the whole app.
  # The environment.d drop-in below computes this correctly, but GNOME's own
  # session startup overwrites XDG_DATA_DIRS wholesale afterward (confirmed via
  # journalctl/systemctl --user show-environment on both penglaptop and penglpc:
  # the generator's output is right, the live session's isn't), so anything
  # relying on ambient session environment loses the schema path by the time
  # XDG autostart apps actually launch. This wrapper re-adds it immediately
  # before exec, in a real shell, so it can't be clobbered upstream.
  xdg.configFile."autostart/com.seafile.seafile-applet.desktop".text = ''
    [Desktop Entry]
    Name=Seafile
    Comment=Seafile desktop sync client
    TryExec=seafile-applet
    Exec=${pkgs.writeShellScript "seafile-applet-launch" ''
      export XDG_DATA_DIRS="${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS"
      exec ${pkgs.seafile-client}/bin/seafile-applet
    ''}
    Icon=seafile
    Type=Application
    Categories=Network;FileTransfer;
  '';

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

    settings."*" = {
      identitiesOnly = true;
    };

    settings."github.com" = {
      identityFile = "~/.ssh/id_ed25519";
    };

    settings."github.coecis.cornell.edu" = {
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
        pager = "diff-so-fancy | less --tabs=4 -RF"; # Add this
      };

      push = {
        autoSetupRemote = true;
      };

      # Add this block
      interactive = {
        diffFilter = "diff-so-fancy --patch";
      };

      # Optional: recommended color settings for diff-so-fancy
      color = {
        diff = "always";
        ui = "always";
      };

      "color \"diff\"" = {
        meta = "11";
        frag = "magenta bold";
        func = "146 bold";
        commit = "yellow bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
      };

      "color \"diff-highlight\"" = {
        oldNormal = "red bold";
        oldHighlight = "red bold 52";
        newNormal = "green bold";
        newHighlight = "green bold 22";
      };
    };
  };

  fonts.fontconfig.enable = true;

  # Terminal stuff
  programs.eza = {
    enable = true;
    icons = "auto";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  #Proton
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Best-effort only -- NOT what fixes seafile-applet's crash (see the wrapper
  # in the autostart .desktop entry above for that). Confirmed via
  # `systemctl --user show-environment` on both penglaptop and penglpc that
  # this generator output is correct in isolation, but GNOME's own session
  # startup overwrites XDG_DATA_DIRS wholesale afterward, so by the time
  # XDG-autostart apps actually launch, this addition is already gone. Left
  # in place in case some other, non-autostart use of gtk3's schema benefits
  # from it (e.g. a manually-launched shell), but don't rely on it alone.
  xdg.configFile."environment.d/50-seafile-gtk3-schema.conf".text = ''
    XDG_DATA_DIRS=${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:''${XDG_DATA_DIRS}
  '';

  home.sessionPath = [ "$HOME/.local/bin" ];

  # Nix garbage collection
  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      extraArgs = "--keep 5";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
