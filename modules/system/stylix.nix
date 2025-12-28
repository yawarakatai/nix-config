# Stylix theming configuration
# Provides consistent colors and fonts across all applications
{ pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    # Example wallpaper - replace with your preferred URL
    url = "https://raw.githubusercontent.com/rose-pine/wallpapers/main/rose_pine_shape.png";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
{
  stylix = {
    enable = true;

    # Use RosePine color scheme
    # To generate theme FROM wallpaper instead, remove base16Scheme line
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    # Wallpaper (generated solid color)
    image = wallpaper;

    # Polarity for the theme
    polarity = "dark";

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK JP";
      };

      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK JP";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 14;
        applications = 12;
        desktop = 12;
        popups = 12;
      };
    };

    # Cursor configuration
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 24;
    };

    # Opacity settings
    opacity = {
      terminal = 1.0;
      applications = 1.0;
      desktop = 1.0;
      popups = 0.95;
    };
  };
}
