{
  lib,
  pkgs,
  ...
}:

{
  stylix = {
    enable = true;
    enableReleaseChecks = false;

    image = pkgs.fetchurl {
      url = "https://i.redd.it/mg5w8i3gkstg1.jpeg";
      hash = "sha256-02EacG9i2c4puqQ5VRVPTBZmZDInA8pBC8QG9IMJEn8=";
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono NL Nerd Font";
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

    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Ink";
      size = 32;
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus";
      dark = "Papirus-Dark";
    };

    opacity = {
      terminal = 1.0;
      applications = 1.0;
      desktop = 1.0;
      popups = 0.90;
    };

    targets.qt.platform = lib.mkForce "qtct";
  };
}
