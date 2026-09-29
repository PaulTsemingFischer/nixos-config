# pkgs/default.nix
pkgs: {
  lenovo-vantage = pkgs.callPackage ./lenovo-vantage { };
  orchis-kvantum = pkgs.callPackage ./orchis-kvantum { };
}
