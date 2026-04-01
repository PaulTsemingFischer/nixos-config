{ config, pkgs, ... }:

{
  # EasyEffects for audio effects (equalizer, etc.)
  services.easyeffects = {
    enable = true;
  };

  # Copy EasyEffects profiles to config directory
  home.file.".config/easyeffects/output/YogaPro9i.json" = {
    source = ./easyeffects/YogaPro9i.json;
  };

  # Auto-load the profile on startup
  home.file.".config/easyeffects/autoload/output/default" = {
    text = "YogaPro9i";
  };
}
