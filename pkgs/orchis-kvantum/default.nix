# pkgs/orchis-kvantum/default.nix
# Kvantum theme extracted from the Orchis KDE theme suite. Upstream ships
# Plasma/Aurorae/SDDM assets too, but those only matter under real Plasma;
# we're only using this to theme standalone Qt apps (e.g. Dolphin) via
# Kvantum on a non-Plasma desktop, so just the Kvantum/ subdir is installed.
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "orchis-kvantum";
  version = "unstable-2025-10-18";

  # https://github.com/vinceliuice/Orchis-kde
  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "b2a96919eee40264e79db402b915f926436100ad";
    hash = "sha256-mO1AVrnXNdg3Rftj0cQWef/RrBgSDy5kaMHagwKywEo=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum
    cp -r Kvantum/* $out/share/Kvantum/
    runHook postInstall
  '';

  meta = {
    description = "Kvantum theme from the Orchis KDE theme suite";
    homepage = "https://github.com/vinceliuice/Orchis-kde";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
