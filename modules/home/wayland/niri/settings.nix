{ theme, vars, ... }:

{
  programs.niri.settings = {
    # Input configuration
    input = {
      keyboard = {
        xkb = {
          layout = "us";
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
    # Monitor names from vars.monitors
    outputs = {
      "${builtins.head vars.monitors}" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 143.999;
        };
        scale = if vars.hasHiDPI then 1.0 else 1.0;
        position = { x = 0; y = 0; };
      };
    };

    # Layout configuration
    layout = {
      background-color = theme.colorScheme.base00;

      gaps = theme.gaps.inner;
      border.enable = false;
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
