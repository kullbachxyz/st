{ lib
, stdenv
, pkg-config
, xorg
, libXft
, fontconfig
, freetype
, ncurses
}:

stdenv.mkDerivation {
  pname = "st-custom";
  version = "local";

  src = ./.;

  nativeBuildInputs = [
    pkg-config
    ncurses
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXft
    libXft
    fontconfig
    freetype
  ];

  prePatch = ''
    sed -i "s|/usr/local|$out|g" config.mk
    sed -i "s|^X11INC = .*|X11INC = ${xorg.libX11.dev}/include|g" config.mk
    sed -i "s|^X11LIB = .*|X11LIB = ${xorg.libX11}/lib|g" config.mk
    sed -i "s|^PKG_CONFIG = .*|PKG_CONFIG = pkg-config|g" config.mk || true
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/terminfo

    install -Dm755 st $out/bin/st

    if [ -f st.1 ]; then
      sed "s/VERSION/local/g" < st.1 > $out/share/man/man1/st.1
      chmod 644 $out/share/man/man1/st.1
    fi

    ${ncurses}/bin/tic -sx -o $out/share/terminfo st.info

    runHook postInstall
  '';

  meta = {
    description = "Custom local st build";
    homepage = "https://st.suckless.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
