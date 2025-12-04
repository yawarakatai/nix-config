{
  description = "Bevy game development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
      in
      {
        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = with pkgs; [
            pkg-config
            rustToolchain
            cargo-watch  # ホットリロード用
          ];

          buildInputs = with pkgs; [
            # Bevy dependencies
            udev
            alsa-lib
            vulkan-loader

            # Wayland (Niri用)
            libxkbcommon
            wayland

            # X11 (念のため)
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;

          shellHook = ''
            echo "🎮 Bevy development environment ready!"
            echo "Rust: $(rustc --version)"
          '';
        };
      }
    );
}
