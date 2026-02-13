# Stylix theming configuration
# Provides consistent colors and fonts across all applications
{ pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://cdnb.artstation.com/p/assets/images/images/024/049/327/large/rodion-yushmanov-dsc-0198.jpg?1581157890";
    hash = "sha256-xJyvFH4zyHApiOjYEtgVPSeXz+ghuAIHs1fH8qCy8Z4=";
  };

  processedWallpaper =
    pkgs.runCommand "processed-wallpaper.png"
      {
        buildInputs = [ pkgs.imagemagick ];
      }
      ''
        magick ${wallpaper} \
        -blur 0x10 \
        -brightness-contrast -10x0 \
        $out
      '';

  miku-cursor = pkgs.stdenv.mkDerivation {
    pname = "miku-cursor-linux";
    version = "1.2.6";

    src = pkgs.fetchFromGitHub {
      owner = "supermariofps";
      repo = "hatsune-miku-windows-linux-cursors";
      rev = "471ff88156e9a3dc8542d23e8cae4e1c9de6e732";
      sha256 = "sha256-HCHo4GwWLvjjnKWNiHb156Z+NQqliqLX1T1qNxMEMfE=";
    };

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r miku-cursor-linux $out/share/icons/
    '';
  };
in
{
  stylix = {
    enable = true;

    # Wallpaper image
    image = processedWallpaper;

    # To generate theme FROM wallpaper instead, remove base16Scheme line
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

    # Polarity for the theme
    polarity = "dark";

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "Iosevka Term Nerd Font";
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
      size = 32;
    };

    # cursor = {
    #   package = miku-cursor;
    #   name = "miku-cursor-linux";
    #   size = 32;
    # };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus";
      dark = "Papirus-Dark";
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
