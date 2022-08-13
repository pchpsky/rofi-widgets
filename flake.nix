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
            relude = super.relude_1_1_0_0;
            doctest = super.doctest_0_20_0;
          };
        };

        jailbreakUnbreak = pkg:
          pkgs.haskell.lib.doJailbreak (pkg.overrideAttrs (_: { meta = { }; }));

        rofi-widgets = haskellPackages.callCabal2nix "rofi-widgets" ./. rec {};

        powermenu = haskellPackages.callCabal2nix "rofi-widgets-powermenu" ./. rec {};
      in {
        packages.rofi-widgets = rofi-widgets;
        legacyPackages.rofi-widgets = rofi-widgets;

        packages.rofi-widgets-powermenu = powermenu;
        legacyPackages.rofi-widgets-powermenu = powermenu;

        defaultPackage = self.packages.${system}.rofi-widgets;

        devShell = pkgs.mkShell {
          buildInputs = with haskellPackages; [
            haskell-language-server
            ghcid
            cabal-install
            pkgs.zlib
            cabal2nix
          ];
          inputsFrom = builtins.attrValues self.packages.${system};

          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.zlib}/lib
          '';
        };
      });
}
