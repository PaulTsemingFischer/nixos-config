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

      #Jump
      jc = "cd ~/Documents/nix-config";
      jh = "cd ~/Documents/nix-config/home-manager";

      #Edit
      ec = "sudo nano ~/Documents/nix-config/nixos/configuration.nix";
      eh = "nano ~/Documents/nix-config/home-manager/home.nix";
      ea = "nano ~/Documents/nix-config/home-manager/aliases.nix";

      #nixos
      nfmt = "nix fmt ./";

      # rb = "nix fmt ~/Documents/nix-config; sudo nixos-rebuild switch --flake ~/Documents/nix-config#nixos";
      # rh = "nix fmt ~/Documents/nix-config; home-manager switch --flake ~/Documents/nix-config#pengl@nixos";
      rb = "(cd ~/Documents/nix-config && nix fmt ./); sudo nixos-rebuild switch --flake ~/Documents/nix-config#nixos";
      rh = "(cd ~/Documents/nix-config && nix fmt ./); home-manager switch --flake ~/Documents/nix-config#pengl@nixos";

      #system
      hiberate = "sudo systemctl hibernate";
      bye = "shutdown -r now";
      hg = "history | grep $1";

      #git
      gl = "git log --oneline";
      gld = "git log --oneline --decorate --graph --all";
      gs = "git status";
      #      ga = "git add .";
      #     gc = "git commit -m $1";
      #    gac = "git add .; git commit -m $1";
      #  gacp = "git add .; git commit -m $1; git push";
    };
    initExtra = ''
      #      gaa() { git add .; }
      #      gcmsg() { git commit -m "$1"; }
            gac() { gaa && gcmsg "$1"; }
            gacp() { gaa && gcmsg "$1" && gp; }
    '';
  };
}
