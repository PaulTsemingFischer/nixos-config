{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    #enable = true;
    shellAliases = {
      #OMZ
      ls = "exa --icons";

      nfmt = "nix fmt ./";
      rb = "nix fmt ./; sudo nixos-rebuild switch --flake .#nixos";
      rh = "nix fmt ./; home-manager switch --flake .#pengl@nixos";
      hiberate = "sudo systemctl hibernate";
      bye = "shutdown -r now";
      hg = "history | grep $1";

      #git
      gl = "git log --oneline";
      gld = "git log --oneline --decorate --graph --all";
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m $1";
      gac = "ga; gc;";
      gp = "git push";
      gacp = "ga; gc; gp;";
    };
  };
}
