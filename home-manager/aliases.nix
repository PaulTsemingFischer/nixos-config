{
  config,
  lib,
  pkgs,
  ...
}: {
  program.zsh = {
    enable = true;
    shellAliases = {
      rb = "sudo nixos-rebuild switch --flake .#nixos";
      rh = "home-manager switch --flake .#pengl@nixos";
      nfmt = "nix fmt ./";
      hiberate = "sudo systemctl hibernate";
      bye = "shutdown -r now";
      hg = "history | grep $1";

      #git
      gl = "git log --oneline";
      gld = "git log --oneline --decorate --graph --all";
      gs = "git status";
      gs = "git commit -m $1";
      gp = "git push";
    };
  };
}
