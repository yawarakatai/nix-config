{
  config,
  lib,
  pkgs,
  ...
}:

{
  stylix = {
    enable = true;
    enableReleaseChecks = false;

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
      terminal = config.my.theme.opacity.terminal;
      applications = config.my.theme.opacity.applications;
      desktop = config.my.theme.opacity.desktop;
      popups = config.my.theme.opacity.popups;
    };

    targets.qt.platform = lib.mkForce "qtct";
  };
}
