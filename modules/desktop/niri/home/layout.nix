{ lib, osConfig, ... }:

let
  inherit (osConfig.my) niri wallpaper;
in
{
  wayland.windowManager.niri.settings = {
    _children = lib.mkMerge [
      (lib.mkBefore [
        {
          window-rule = {
            draw-border-with-background = false;
            geometry-corner-radius = lib.replicate 4 (niri.rounding * 1.0);
            clip-to-geometry = true;
          };
        }
      ])
      [
        {
          layer-rule = {
            match._props.namespace = "^noctalia-overview";
            place-within-backdrop = true;
          };
        }
      ]
    ];

    layout = {
      background-color = wallpaper.fallbackColor;

      always-center-single-column = { };
      center-focused-column = "never";
      inherit (niri) gaps;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };

      border = {
        inherit (niri.border) width;
        active-color = niri.border.color;
        inactive-color = niri.border.inactiveColor;
        urgent-color = niri.border.urgentColor;
      }
      // lib.optionalAttrs (!niri.border.enable) { off = { }; };

      focus-ring.off = { };

      preset-column-widths._children = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width.proportion = 0.5;
      preset-window-heights._children = [ { proportion = 0.5; } ];
    };

    overview.backdrop-color = wallpaper.fallbackColor;
  };
}
