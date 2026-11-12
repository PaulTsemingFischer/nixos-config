{ lib, pkgs, ... }:
let
  tokyoNightTheme = pkgs.fetchFromGitHub {
    owner = "SirHades696";
    repo = "TokyoNight-Ulauncher-Theme";
    rev = "1f8cc77df1da2d295f99a5ccf696a6fa4184d5b2";
    sha256 = "sha256-8aFpZR01lZ13mQm+9DfEcKNHhENWa5G2XWYzUCiZ8fI=";
  };
in
{
  home.packages = [ ];

  # Ulauncher compiles the active theme's CSS into a generated.css file
  # inside the theme's own directory on every launch
  # (Theme._get_path_for_generated_css in its source). A home.file symlink
  # into the read-only Nix store breaks that write, crashing ulauncher on
  # every fresh start with "Read-only file system: .../generated.css" --
  # so copy the theme into a real, writable directory instead.
  home.activation.ulauncherTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    THEME_DIR="$HOME/.config/ulauncher/user-themes/TokyoNight"
    $DRY_RUN_CMD rm -rf "$THEME_DIR"
    $DRY_RUN_CMD mkdir -p "$(dirname "$THEME_DIR")"
    $DRY_RUN_CMD cp -r ${tokyoNightTheme}/TokyoNight "$THEME_DIR"
    $DRY_RUN_CMD chmod -R u+w "$THEME_DIR"
  '';

  home.file.".config/ulauncher/settings.json".text = builtins.toJSON {
    theme-name = "TokyoNight-Theme";
    show-indicator-icon = true;
    show-recent-apps = 0;
    clear-previous-query = true;
    render-on-screen = "default";
  };

  # Launch the ulauncher daemon hidden on login. The <Super>r keybinding
  # (home-manager/desktop/gnome/gnome.nix) only calls ulauncher-toggle,
  # which talks to an already-running daemon over D-Bus and does nothing
  # if one isn't up yet.
  xdg.configFile."autostart/ulauncher.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Ulauncher
    Exec=${pkgs.ulauncher}/bin/ulauncher --hide-window
    X-GNOME-Autostart-enabled=true
  '';
}
