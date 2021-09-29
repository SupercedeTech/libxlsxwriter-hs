let
  rev = "07ca3a021f05d6ff46bbd03c418b418abb781279"; # first 21.05 release
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  compiler = "ghc8104";
  pkgs = import (builtins.fetchTarball url) {
    config = {
      packageOverrides = super: {
        libxlsxwriter = super.libxlsxwriter.overrideAttrs (oldAttrs: {
          # use_dtoa_library: for 40-50% faster double-to-string conversion
          makeFlags = oldAttrs.makeFlags ++ ["USE_DTOA_LIBRARY=1"];
        });
      };
    };
  };

  hpkgs = pkgs.haskell.packages."${compiler}";
in
hpkgs.developPackage {
  root = ./.;
  withHoogle = false;
  modifier = drv: with pkgs.haskell.lib; addExtraLibrary (addBuildTools drv [
    pkgs.cabal-install
    hpkgs.c2hs
  ])
  pkgs.libxlsxwriter;
}
