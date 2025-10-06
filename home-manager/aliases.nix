{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    shellAliases = {
      #OMZ
      ls = "exa --icons";

      #Jump
      jc = "cd ~/Documents/nix-config";
      jh = "cd ~/Documents/nix-config/home-manager";

      #Edit
      ec = "code ~/Documents/nix-config/nixos/configuration.nix";
      ecd = "code ~/Documents/nix-config";
      eh = "code ~/Documents/nix-config/home-manager/home.nix";
      ea = "code ~/Documents/nix-config/home-manager/aliases.nix";

      #nixos
      nfmt = "nix fmt ./";
      rb = "(cd ~/Documents/nix-config && nix fmt ./); sudo nixos-rebuild switch --flake ~/Documents/nix-config#nixos";
      rh = "(cd ~/Documents/nix-config && nix fmt ./); home-manager switch --flake ~/Documents/nix-config#pengl@nixos";

      #system
      hibernate = "sudo systemctl hibernate";
      bye = "shutdown -r now";
      hg = "history | grep $1";

      #git
      gl = "git log --oneline";
      gld = "git log --oneline --decorate --graph --all";
      gs = "git status";
    };
    initExtra = ''
      #      gaa() { git add .; }
      #      gcmsg() { git commit -m "$1"; }
            gac() { gaa && gcmsg "$1"; }
            gacp() { gaa && gcmsg "$1" && gp; }
    '';
  };
}
