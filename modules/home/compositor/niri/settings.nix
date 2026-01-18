{
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  monitors = osConfig.my.system.monitors;
in
{
  programs.niri.settings = {
    # Input configuration
    input = {
      keyboard = {
        xkb = {
          layout = "us";
          # options = "ctrl:nocaps";
        };
        repeat-delay = 300;
        repeat-rate = 50;
      };

      touchpad = {
        tap = true;
        natural-scroll = true;
        accel-speed = 1.0;
      };

      mouse = {
        accel-speed = 0.0;
        accel-profile = "flat";
      };

      trackpoint = {
        accel-speed = 1.0;
        accel-profile = "flat";
      };
    };

    # Output configuration
    outputs = {
      "${monitors.primary.name}" = {
        mode = {
          width = monitors.primary.width;
          height = monitors.primary.height;
          refresh = monitors.primary.refresh;
        };
        variable-refresh-rate = if monitors.primary.vrr then "on-demand" else false;
        scale = monitors.primary.scale;
        position = monitors.primary.position;
      };
    };

    window-rules = lib.mkBefore [
      {
        draw-border-with-background = false;
        geometry-corner-radius =
          let
            r = osConfig.my.theme.rounding * 1.0;
          in
          {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
        clip-to-geometry = true;
      }
    ];

    # Mouse Cursor configuration
    # cursor = {
    #   size = stylix.cursor.size;
    #   theme = stylix.cursor.name;
    # };

    # Layout configuration
    layout = {
      background-color = "transparent";

      always-center-single-column = true;

      gaps = osConfig.my.theme.gaps.inner;

      border = {
        enable = osConfig.my.theme.border.enable;
        width = osConfig.my.theme.border.width;
      };

      focus-ring.enable = false;

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width = {
        proportion = 0.33333;
      };

      preset-window-heights = [
        { proportion = 0.5; }
      ];
    };

    layer-rules = [
      {
        matches = [
          { namespace = "^wallpaper$"; }
        ];
        place-within-backdrop = true;
      }
    ];

    # Workspaces
    workspaces = {
      "1" = { };
      "2" = { };
      # "3" = { };
      # "4" = { };
      # "5" = { };
    };

    overview = {
      workspace-shadow.enable = false;
    };

    xwayland-satellite = {
      path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
    };

    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    # Animations
    animations = {
      enable = true;
      slowdown = 1.0;
    };

    # Misc
    prefer-no-csd = true;

    # Environment
    environment = {
      # Set DISPLAY for X11 applications (via xwayland-satellite)
      DISPLAY = ":0";

      # Required for xdg-desktop-portal to work correctly with niri
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
