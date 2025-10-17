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
      rs = "(cd ~/Documents/nix-config && nix fmt ./; gaa); sudo nixos-rebuild switch --flake ~/Documents/nix-config#nixos";
      rh = "(cd ~/Documents/nix-config && nix fmt ./; gaa); home-manager switch --flake ~/Documents/nix-config#pengl@nixos";
      ra = "rs; rh";

      #system
      hibernate = "sudo systemctl hibernate";
      bye = "shutdown -r now";
      hg = "history | grep $1";

      #git
      gl = "git log --oneline";
      gld = "git log --oneline --decorate --graph --all";
      gs = "git status";

      #Steam(can't put these in launch options, aliases aren't working there)
      steam-nvidia = "DRI_PRIME=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%";
      msteam-nvidia = "mangohud DRI_PRIME=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%";
    };
    initContent = ''
      gac() { gaa && gcmsg "$1"; }
      gacp() { gaa && gcmsg "$1" && gp; }
    '';
  };
}
