{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  zenity,
  xorg,
  networkmanager,
  pulseaudio,
  polkit,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "lenovo-vantage-linux";
  version = "unstable-2024-01-03";

  src = fetchFromGitHub {
    owner = "niizam";
    repo = "vantage";
    rev = "641ca63dc5f133ee884d358ad6d253fa70f69988";
    sha256 = "sha256-1gpcixyfr351b4i0978kpyjgis60vbrzvh1rlpivyk1qspk477hy";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash
    zenity
    xorg.xinput
    networkmanager
    pulseaudio
    polkit
  ];

  dontBuild = true;

  installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        mkdir -p $out/share/applications

        cp vantage.sh $out/bin/lenovo-vantage
        chmod +x $out/bin/lenovo-vantage

        wrapProgram $out/bin/lenovo-vantage \
          --prefix PATH : ${
            lib.makeBinPath [
              zenity
              xorg.xinput
              networkmanager
              pulseaudio
              polkit
              bash
            ]
          }

        cat > $out/share/applications/lenovo-vantage.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=Lenovo Vantage
    Comment=Control Lenovo laptop features
    Exec=$out/bin/lenovo-vantage
    Icon=computer-laptop
    Terminal=false
    Categories=System;Settings;
    Keywords=lenovo;vantage;battery;fan;
    EOF

        runHook postInstall
  '';

  meta = with lib; {
    description = "Lenovo Vantage for Linux";
    homepage = "https://github.com/niizam/vantage";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
