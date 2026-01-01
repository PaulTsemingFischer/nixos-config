{
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "colorize"
        "colored-man-pages"
        "command-not-found"
      ];
      theme = "agnoster";
    };
    initContent = ''
      ${builtins.readFile ./powerline-prompt.sh}
      eval $(opam env)
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.pay-respects.enable = true;
}
