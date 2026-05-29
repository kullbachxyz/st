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
    mkdir -p $out/bin $out/share/man/man1
    make PREFIX=$out install
    runHook postInstall
  '';

  meta = {
    description = "Custom local st build";
    homepage = "https://st.suckless.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
