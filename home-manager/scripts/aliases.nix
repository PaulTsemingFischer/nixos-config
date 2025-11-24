{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    shellAliases = {
      # Shell
      ls = "exa --icons";
      rzsh = "source ~/.zshrc";

      #Jump
      jc = "cd ~/Documents/nix-config";
      jh = "cd ~/Documents/nix-config/home-manager";
      jd = "cd ~/Dropbox";
      j4414 = "jd; cd cs4414";
      j3110 = "jd; cd cs3110";
      j4110 = "jd; cd cs4110";
      jcuair = "cd ~/cuair";
      jcgb = "jcuair; cd gs-backend";
      jcgc = "jcuair; cd cs-backend";
      jcfb = "jcuair; cd gs-frontend";
      jcfc = "jcuair; cd cs-frontend";

      #Edit
      ec = "code ~/Documents/nix-config/nixos/configuration.nix";
      ecd = "code ~/Documents/nix-config";
      eh = "code ~/Documents/nix-config/home-manager/home.nix";
      ea = "code ~/Documents/nix-config/home-manager/aliases.nix";

      # Format all nix files
      nfmt = "nix fmt ./";

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

      #ssh
      sshc = "ssh ptf34@ugclinux.cs.cornell.edu";
      sshcy = "ssh -Y ptf34@ugclinux.cs.cornell.edu";

      #local dev
      ldev = "cp ${toString ./bareflake.nix} ./flake.nix && echo 'use flake .' > .envrc && direnv allow";
    };

    initContent = ''
      # Function to get current hostname for flake configuration
      get_flake_host() {
        local hostname=$(hostname)
        echo "$hostname"
      }

      # Dynamic NixOS rebuild
      rs() {
        local host=$(get_flake_host)
        (cd ~/Documents/nix-config && nix fmt ./; gaa)
        sudo nixos-rebuild switch --flake ~/Documents/nix-config#$host
      }

      # Dynamic home-manager rebuild
      rh() {
        local host=$(get_flake_host)
        (cd ~/Documents/nix-config && nix fmt ./; gaa)
        home-manager switch --flake ~/Documents/nix-config#pengl@$host
      }

      # Rebuild both
      ra() {
        rs
        rh
      }

      # Git helper functions
      gac() { gaa && gcmsg "$1"; }
      gacp() { gaa && gcmsg "$1" && gp; }

      # Silent cd
      cds() {
      cd "$@" > /dev/null 2>&1
      }

      # Run in background silently
      rbg() {
        "$@" &>/dev/null &
      }
    '';
  };
}
