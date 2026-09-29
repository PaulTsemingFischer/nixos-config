{ lib, pkgs, ... }:
let
  # kdePackages.dolphin's nixpkgs wrapper unconditionally overwrites
  # QT_PLUGIN_PATH with only Dolphin's own build closure, which drops the
  # Kvantum plugin installed via home-manager's `qt.style.package` (see
  # ./qt.nix). Re-wrap it with an extra `--prefix` so Kvantum still gets
  # found. This doesn't rebuild Dolphin from source: symlinkJoin reuses the
  # existing build and only regenerates the small wrapper script around the
  # binary. The .desktop file uses a bare `Exec=dolphin %u`, so launching
  # from the app grid picks up this wrapper via PATH.
  dolphin = pkgs.symlinkJoin {
    name = "dolphin-kvantum";
    paths = [ pkgs.kdePackages.dolphin ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/dolphin \
        --prefix QT_PLUGIN_PATH : "${pkgs.kdePackages.qtstyleplugin-kvantum}/lib/qt-6/plugins"
    '';
  };
in
{
  home.packages = [
    dolphin

    # Things Nautilus used to cover, now that it's excluded in
    # nixos/desktop/gnome.nix.
    pkgs.kdePackages.ark # archive viewer/extractor
    pkgs.kdePackages.kio-extras # trash:/, network:/, mtp:/, sftp:/ and thumbnailers
    pkgs.kdePackages.ffmpegthumbs # video thumbnails
    pkgs.kdePackages.kdegraphics-thumbnailers # PDF/SVG/raw-image thumbnails
    pkgs.kdePackages.qtsvg # SVG previews
  ];

  # "Show in file manager" / "Open containing folder" in GTK and Electron apps
  # goes through the org.freedesktop.FileManager1 D-Bus name rather than the
  # mimeapps default. Dolphin ships a .service file claiming that name which
  # defers to this systemd unit, but the unit in the package execs the
  # *unwrapped* binary — override it so the daemon-launched window is themed
  # like every other Dolphin window. Fields mirror the upstream unit.
  systemd.user.services.plasma-dolphin = {
    Unit = {
      Description = "Dolphin file manager";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${dolphin}/bin/dolphin --daemon";
      BusName = "org.freedesktop.FileManager1";
      Slice = "background.slice";
    };
  };

  # Dolphin's "Open Terminal Here" goes through KIO's OpenTerminalJob, which
  # reads these two keys out of kdeglobals; point them at wezterm instead of
  # the KDE default (konsole, which isn't installed). Written imperatively
  # rather than via home.file because Dolphin also writes kdeglobals itself
  # (preview settings), and a read-only symlink would break saving those.
  home.activation.dolphinTerminal = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals \
      --group General --key TerminalService org.wezfurlong.wezterm.desktop
    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals \
      --group General --key TerminalApplication wezterm
  '';
}
