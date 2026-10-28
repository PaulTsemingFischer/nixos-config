{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    shellAliases = {
      # Shell
      ls = "exa --icons";
      rzsh = "source ~/.zshrc";
      count = "find . -type f | wc -l";

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
      fixaudio = "amixer -c 0 cset numid=3 on";
      redisplay = "sudo systemctl restart display-manager";
      reloadniri = "niri msg action load-config-file";
      syncniri = "(cd home-manager/desktop/niri && python ./sync-from-gui.py)";

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

      #only runs when you type it; Ctrl-C disconnects, or use cuvpndown
      #from another terminal)
      cuvpn = "sudo openconnect --protocol=anyconnect --useragent=AnyConnect cuvpn.cuvpn.cornell.edu";
      cuvpndown = "sudo pkill -INT -x openconnect";

      #local dev
      ldev = "cp ${toString ./bareflake.nix} ./flake.nix && echo 'source_up\nuse flake' > .envrc && git add . && direnv allow";

      #apps
      parabolic = "org.nickvision.tubeconverter";
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

      # Loud cd
      cde() {
        if builtin cd "$@"; then
          ls
        fi
      }

      # Run in background silently
      rbg() {
        eval "$*" &> /dev/null & 
      }

      # Find a file
      ffind() {
          [[ -z "$1" ]] && { echo "Usage: ffind <partial-filename> [dir]" >&2; return 2; }
          local file="$1"
          local dir="''${2:-.}"
          local match
          match=$(find "$dir" -type f -iname "*$file*" -print -quit 2>/dev/null)
          [[ -z "$match" ]] && { echo "No match" >&2; return 1; }
          printf '%s\n' "$match"
      }

      # Temporarily repoint ~/Downloads elsewhere, then revert to ~/Unsorted.
      # Revert is a transient systemd timer, so it survives closing the shell.
      DOWNLOADS_HOME="Unsorted"

      dlto() {
        local link="$HOME/Downloads"
        local dest="$1"
        local dur="''${2:-5min}"
        [[ -z "$dest" ]] && {
          echo "Usage: dlto <dir> [duration]   e.g. dlto ~/Dropbox/cs4414 10min" >&2
          return 2
        }
        if [[ -e "$link" && ! -L "$link" ]]; then
          echo "dlto: $link is a real directory, not a symlink - refusing to touch it" >&2
          return 1
        fi
        mkdir -p "$dest" || return 1
        systemctl --user stop dlto-revert.timer 2>/dev/null
        systemctl --user reset-failed dlto-revert.timer dlto-revert.service 2>/dev/null
        ln -sfn "''${dest:A}" "$link" || return 1
        if systemd-run --user --quiet --collect --unit=dlto-revert --on-active="$dur" \
             ln -sfn "$HOME/$DOWNLOADS_HOME" "$link"; then
          echo "~/Downloads -> ''${dest:A}   (reverts to ~/$DOWNLOADS_HOME in $dur)"
        else
          echo "dlto: could not schedule the revert, putting it back now" >&2
          dlback
          return 1
        fi
      }

      # Revert ~/Downloads immediately and cancel any pending revert.
      dlback() {
        systemctl --user stop dlto-revert.timer 2>/dev/null
        systemctl --user reset-failed dlto-revert.timer dlto-revert.service 2>/dev/null
        ln -sfn "$HOME/$DOWNLOADS_HOME" "$HOME/Downloads"
        echo "~/Downloads -> $(readlink -f "$HOME/Downloads")"
      }
    '';
  };
}
