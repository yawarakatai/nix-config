{
  config,
  lib,
  pkgs,
  ...
}:

let
  effectiveOpacity = value: if config.my.theme.transparency.enable then value else 1.0;
  stylixColors = config.lib.stylix.colors.withHashtag;
in
{
  my.niri.border = {
    color = lib.mkDefault stylixColors.base05;
    inactiveColor = lib.mkDefault stylixColors.base01;
    urgentColor = lib.mkDefault stylixColors.base08;
  };
  my.wallpaper.fallbackColor = lib.mkDefault stylixColors.base00;

  stylix = {
    enable = true;
    enableReleaseChecks = false;

    base16Scheme = ./schemes/discovery.yaml;

    polarity = "dark";

    fonts = {
      monospace = {
        package = config.my.theme.fonts.monospace.package;
        name = config.my.theme.fonts.monospace.name;
      };

      sansSerif = {
        package = config.my.theme.fonts.sansSerif.package;
        name = config.my.theme.fonts.sansSerif.name;
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
      package = pkgs.papirus-icon-theme.override { color = "brown"; };
      light = "Papirus";
      dark = "Papirus-Dark";
    };

    opacity = {
      terminal = effectiveOpacity config.my.theme.opacity.terminal;
      applications = effectiveOpacity config.my.theme.opacity.applications;
      desktop = effectiveOpacity config.my.theme.opacity.desktop;
      popups = effectiveOpacity config.my.theme.opacity.popups;
    };

    targets.qt.platform = lib.mkForce "qtct";
  };
}
