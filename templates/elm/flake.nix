{
  description = "Elm development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Elm compiler and tools
            elmPackages.elm
            elmPackages.elm-format
            elmPackages.elm-test
            elmPackages.elm-review
            elmPackages.elm-json
            
            # Development server for live reload
            elmPackages.elm-live
            
            # Optional: Node.js for additional tooling
            nodejs
          ];

          shellHook = ''
            echo "Elm development environment loaded"
            echo "Elm version: $(elm --version)"
            echo ""
            echo "Available commands:"
            echo "  elm init          - Initialize a new Elm project"
            echo "  elm reactor       - Start Elm reactor (dev server)"
            echo "  elm make          - Compile Elm code"
            echo "  elm-format        - Format Elm code"
            echo "  elm-test          - Run tests"
            echo "  elm-live          - Live reload development server"
          '';
        };
      }
    );
}
