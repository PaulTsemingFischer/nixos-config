{
  ...
}:
# === Mako ===
{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1a1b26";
      text-color = "#c0caf5";
      border-color = "#f38ba8";
      border-radius = 6;
      border-size = 2;
      width = 340;
      height = 100;
      margin = "12";
      padding = "12";
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      font = "JetBrains Mono Nerd Font 12";
      max-icon-size = 48;
      "[urgency=low]" = {
        border-color = "#565f89";
        default-timeout = 3000;
      };
      "[urgency=high]" = {
        border-color = "#f38ba8";
        background-color = "#2d1b2e";
        default-timeout = 0;
      };
    };
  };
}
