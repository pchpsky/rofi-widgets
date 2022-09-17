# SPDX-FileCopyrightText: 2021 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: CC0-1.0

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskellPackages.override {
          overrides = self: super: rec {
            # relude = super.relude_1_1_0_0;
            # doctest = super.doctest_0_20_0;
          };
        };

        jailbreakUnbreak = pkg:
          pkgs.haskell.lib.doJailbreak (pkg.overrideAttrs (_: { meta = { }; }));

        widgets = haskellPackages.callCabal2nix "widgets" ./. rec {};
      in {
        packages.widgets = widgets;
        legacyPackages.widgets = widgets;

        defaultPackage = self.packages.${system}.widgets;

        devShell = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
          buildInputs = with haskellPackages; [
            haskell-language-server
            ghcid
            cabal-install
            pkgs.zlib
            pkgs.gtk4.dev
            pkgs.glib
            pkgs.pcre.dev
            pkgs.atk.dev
            pkgs.gmp.dev
            pkgs.libffi.dev
            pkgs.xorg.libXrandr.dev
            pkgs.xorg.libXScrnSaver
          ];
          inputsFrom = builtins.attrValues self.packages.${system};

          shellHook = ''
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.gmp}/lib:${pkgs.libffi}/lib:${pkgs.zlib}/lib
          '';
        };
      });
}
