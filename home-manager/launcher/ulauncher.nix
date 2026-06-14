{ pkgs, ... }:
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

  home.file.".config/ulauncher/user-themes/TokyoNight".source = "${tokyoNightTheme}/TokyoNight";

  home.file.".config/ulauncher/settings.json".text = builtins.toJSON {
    hotkey-show-app = "Super+r";
    theme-name = "TokyoNight-Theme";
    show-indicator-icon = true;
    show-recent-apps = 0;
    clear-previous-query = true;
    render-on-screen = "default";
  };
}
