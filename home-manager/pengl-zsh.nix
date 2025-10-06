{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "thefuck"];
      theme = "agnoster";
    };
    initExtra = ''
      ${builtins.readFile ./powerline-prompt.sh}
    '';
  };
}
