{ theme, vars, ... }:

{
  programs.niri.settings = {
    # Input configuration
    input = {
      keyboard = {
        xkb = {
          layout = "us";
          options = "ctrl:nocaps";
        };
        repeat-delay = 300;
        repeat-rate = 50;
      };

      mouse = {
        accel-speed = 0.0;
        accel-profile = "flat";
      };

      touchpad = {
        tap = true;
        natural-scroll = true;
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
        variable-refresh-rate = if vars.monitors.primary.vrr then "on-demand" else "off";
        scale = vars.monitors.primary.scale;
        position = vars.monitors.primary.position;
      };
      # Additional monitors can be added here by extending vars.monitors
    };

    # Mouse Cursor configuration
    cursor = {
      theme = "graphite-dark";
    };

    # Layout configuration
    layout = {
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
    };

    # Workspaces
    workspaces = {
      "1" = { };
      "2" = { };
      "3" = { };
      "4" = { };
      "5" = { };
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
      # Set default applications
    };
  };
}
