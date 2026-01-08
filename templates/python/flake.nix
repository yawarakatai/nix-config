{
  description = "Python development environment with uv and ruff";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # --- PACKAGES ---
          packages = with pkgs; [
            # Python interpreter (change version as needed, e.g., python311)
            python3

            # Modern Python tools
            uv # Fast Python package installer and uninstaller
            ruff # Extremely fast Python linter and code formatter
          ];

          # --- BUILD INPUTS ---
          # Libraries required for building some Python wheels from source
          buildInputs = with pkgs; [
            zlib
            stdenv.cc.cc.lib # for libstdc++
          ];

          # --- SHELL HOOK ---
          shellHook = ''
            # Set LD_LIBRARY_PATH
            # This is crucial on NixOS to allow python wheels (binaries) downloaded by uv
            # to find system libraries like libstdc++ or zlib.
            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.stdenv.cc.cc.lib
                pkgs.zlib
              ]
            }:$LD_LIBRARY_PATH"

            # Activate the virtual environment
            source .venv/bin/activate

            echo "Python $(python --version) environment activated."
            echo "uv version: $(uv --version)"
            echo "ruff version: $(ruff --version)"
          '';
        };
      }
    );
}
