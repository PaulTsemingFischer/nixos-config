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
    initContent = ''
      ${builtins.readFile ./powerline-prompt.sh}
      eval $(opam env)
    '';
  };
}
