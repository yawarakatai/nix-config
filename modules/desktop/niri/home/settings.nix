{

  osConfig,
  lib,
  pkgs,
  ...
}:

let
  outputs = osConfig.my.display.outputs;
  wallpaper = osConfig.my.wallpaper;
in
{
  programs.niri.settings = {
    # Input configuration
    input = {
      keyboard = {
        # xkb = {
        #   layout = "us";
        #   options = "ctrl:nocaps";
        # };
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
    outputs = lib.mapAttrs (_name: output: {
      inherit (output) enable;
      mode = {
        inherit (output) width height refresh;
      };
      variable-refresh-rate = if output.vrr then "on-demand" else false;
      inherit (output) scale position;
      transform.rotation = output.transform;
    }) outputs;

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

    # Layout configuration
    layout = {
      background-color = if wallpaper.image == null then wallpaper.fallbackColor else "transparent";

      always-center-single-column = true;

      gaps = osConfig.my.theme.gaps;

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
        proportion = 0.5;
      };

      preset-window-heights = [
        { proportion = 0.5; }
      ];
    };

    layer-rules = [
      {
        matches = [
          { namespace = "^noctalia-overview"; }
        ];
        place-within-backdrop = true;
      }
    ];

    # Workspaces
    workspaces = {
      "1" = { };
      "2" = { };
      "3" = { };
      "4" = { };
      # "5" = { };
    };

    overview = {
      backdrop-color = "#0b0f14";
      workspace-shadow.enable = true;
    };

    xwayland-satellite = {
      path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
    };

    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    # Make the active Wayland display available to commands run over SSH.
    spawn-at-startup = [
      {
        argv = [
          "${pkgs.dbus}/bin/dbus-update-activation-environment"
          "--systemd"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
        ];
      }
    ];

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
