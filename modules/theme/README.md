# Theme

`schemes/cold-rain.nix` is the canonical Cold Rain palette, based on the
Ghostty colors. It contains the full Ghostty ANSI normal/bright palette and a Base16
mapping for Stylix. Base16 has fewer slots than the Ghostty palette, so some
bright ANSI colors are specific to Ghostty.

Stylix applies the Base16 colors to supported applications and generates the
Helix theme on NixOS. Ghostty uses the exact palette from that file through its
`cold-rain` theme, while Stylix still controls its font and opacity.
The standalone portable Home Manager profile uses Helix's built-in `tokyonight`
theme because it does not import Stylix.

Compositor layout and shell behavior belong to their respective modules rather
than this directory.
