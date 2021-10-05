{ pkgs ? import ./nixpkgs.nix,
  compiler ? "ghc8104"
}:

let
  hpkgs = pkgs.haskell.packages."${compiler}";
in
hpkgs.developPackage {
  root = ./.;
  withHoogle = false;
  modifier = drv: with pkgs.haskell.lib;
    addExtraLibrary (
      addBuildTools drv [
        pkgs.cabal-install
        hpkgs.c2hs
      ]
    ) pkgs.libxlsxwriter;
}
