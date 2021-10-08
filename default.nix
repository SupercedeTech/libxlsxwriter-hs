{ pkgs ? import ./nixpkgs.nix,
  compiler ? "ghc8104",
  returnShellEnv ? false # purposefully not lib.inNixShell b/c troubles with direnv
}:

let
  hpkgs = pkgs.haskell.packages."${compiler}";
in
hpkgs.developPackage {
  root = ./.;
  withHoogle = false;
  modifier = drv: with pkgs.haskell.lib;
    dontStrip (
      addExtraLibrary (
        addBuildTools drv [
          pkgs.cabal-install
          hpkgs.c2hs
        ]
      ) pkgs.libxlsxwriter);
  inherit returnShellEnv;
}
