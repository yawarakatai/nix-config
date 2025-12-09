{ lib, theme, vars, ... }:

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
    # Monitor configuration from vars.monitors
    outputs = {
      "${vars.monitors.primary.name}" = {
        mode = {
          width = vars.monitors.primary.width;
          height = vars.monitors.primary.height;
          refresh = vars.monitors.primary.refresh;
        };
        variable-refresh-rate = if vars.monitors.primary.vrr then "on-demand" else false;
        scale = vars.monitors.primary.scale;
        position = vars.monitors.primary.position;
      };
    } // lib.optionalAttrs (vars.monitors ? external) {
      "${vars.monitors.external.name}" = {
        mode = {
          width = vars.monitors.external.width;
          height = vars.monitors.external.height;
          refresh = vars.monitors.external.refresh;
        };
        variable-refresh-rate = if vars.monitors.external.vrr then "on-demand" else false;
        scale = vars.monitors.external.scale;
        position = vars.monitors.external.position;
      };
    };

    # Mouse Cursor configuration
    cursor = {
      theme = "graphite-dark";
    };

    # Layout configuration
    layout = {
      always-center-single-column = true;

      background-color = theme.colorScheme.base00;

      gaps = theme.gaps.inner;
      border = {
        enable = theme.border.enable;
        width = theme.border.width;
        active.color = theme.border.activeColor;
        inactive.color = theme.border.inactiveColor;
      };
      focus-ring.enable = false;

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width = { proportion = 0.5; };


      preset-window-heights = [
        { proportion = 0.5; }
      ];
    };

    # Workspaces
    workspaces = {
      "1" = { };
      "2" = { };
      # "3" = { };
      # "4" = { };
      # "5" = { };
    };

    overview = {
      backdrop-color = theme.colorScheme.base00;
      workspace-shadow.enable = false;
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
