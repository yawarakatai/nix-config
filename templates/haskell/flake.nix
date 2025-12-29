{
  description = "Haskell competitive programming environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        hsPkgs = pkgs.haskell.packages.ghc96;

        # GHC with packages included
        ghcWithPackages = hsPkgs.ghcWithPackages (
          ps: with ps; [
            array
            containers
            bytestring
            vector
            mtl
          ]
        );

        # Custom scripts
        run-hs = pkgs.writeShellScriptBin "run" ''
          runghc ''${1:-main.hs}
        '';

        build-hs = pkgs.writeShellScriptBin "build" ''
          ghc -O2 -o ''${2:-main} ''${1:-main.hs}
        '';

        # Run with input file
        test-hs = pkgs.writeShellScriptBin "test-hs" ''
          runghc ''${1:-main.hs} < ''${2:-input.txt}
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            ghcWithPackages
            hsPkgs.cabal-install
            hsPkgs.haskell-language-server

            run-hs
            build-hs
            test-hs
          ];

          shellHook = ''
            echo "GHC: $(ghc --version)"
            echo "HLS: $(haskell-language-server-wrapper --version 2>&1 | head -1)"
          '';
        };
      }
    );
}
