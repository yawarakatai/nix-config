{
  config,
  lib,
  pkgs,
  ...
}:

let
  effectiveOpacity = value: if config.my.theme.transparency.enable then value else 1.0;
  stylixColors = config.lib.stylix.colors.withHashtag;

  wallpaperScheme = {
    scheme = "Wireframe Blue";
    author = "yawarakatai";
    base00 = "0C0C14";
    base01 = "12172A";
    base02 = "1C2C4C";
    base03 = "4C546C";
    base04 = "90AEB0";
    base05 = "B8C7CD";
    base06 = "C5D9E6";
    base07 = "EAF7FF";
    base08 = "D26A91";
    base09 = "6C708F";
    base0A = "9DD2D9";
    base0B = "68A3AE";
    base0C = "6BD5DB";
    base0D = "5398D0";
    base0E = "8291D6";
    base0F = "4C89B4";
  };
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

    base16Scheme = wallpaperScheme;

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
        terminal = 16;
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
      terminal = effectiveOpacity config.my.theme.opacity.terminal;
      applications = effectiveOpacity config.my.theme.opacity.applications;
      desktop = effectiveOpacity config.my.theme.opacity.desktop;
      popups = effectiveOpacity config.my.theme.opacity.popups;
    };

    targets.qt.platform = lib.mkForce "qtct";
  };
}
