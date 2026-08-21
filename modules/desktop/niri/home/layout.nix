{ lib, osConfig, ... }:

let
  inherit (osConfig.my) niri wallpaper;
  transparency = osConfig.my.theme.transparency.enable;
in
{
  programs.niri.settings = {
    window-rules = lib.mkBefore [
      {
        draw-border-with-background = false;
        geometry-corner-radius =
          let
            radius = niri.rounding * 1.0;
          in
          {
            top-left = radius;
            top-right = radius;
            bottom-left = radius;
            bottom-right = radius;
          };
        clip-to-geometry = true;
      }
    ];

    layout = {
      background-color =
        if transparency && wallpaper.image != null then "transparent" else wallpaper.fallbackColor;

      always-center-single-column = true;
      gaps = niri.gaps;

      border = {
        enable = niri.border.enable;
        width = niri.border.width;
        active.color = niri.border.color;
        inactive.color = niri.border.inactiveColor;
        urgent.color = niri.border.urgentColor;
      };

      focus-ring.enable = false;

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width.proportion = 0.5;
      preset-window-heights = [ { proportion = 0.5; } ];
    };

    layer-rules = [
      {
        matches = [ { namespace = "^noctalia-overview"; } ];
        place-within-backdrop = true;
      }
    ];

    workspaces = {
      "1" = { };
      "2" = { };
      "3" = { };
      "4" = { };
    };

    overview = {
      backdrop-color = wallpaper.fallbackColor;
      workspace-shadow.enable = true;
    };
  };
}
