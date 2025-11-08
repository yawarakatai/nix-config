{ config, pkgs, theme, ... }:

{
  programs.niri = {
    settings = {
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
        { command = [ "swaybg" "-i" theme.wallpaper "-m" "fit" ]; }
      ];

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
      outputs = {
        "HDMI-A-2" = {
          mode = {
            width = 3840;
            height = 2160;
            refresh = 143.999;
          };
          scale = 1.0; # Adjust for HiDPI if needed
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

      # Window rules
      # window-rules = [
      #   {
      #     matches = [{ app-id = "firefox"; }];
      #     default-column-width = { proportion = 1.0; };
      #   }
      # ];

      # Keybindings
      binds =
        let
          sh = spawn: [ "sh" "-c" spawn ];
        in
        {
          # Basic window management
          "Mod+Return".action.spawn = "alacritty";
          "Mod+Q".action.close-window = [ ];
          "Mod+H".action.focus-column-left = [ ];
          "Mod+L".action.focus-column-right = [ ];
          "Mod+J".action.focus-window-down = [ ];
          "Mod+K".action.focus-window-up = [ ];
          "Mod+Shift+H".action.move-column-left = [ ];
          "Mod+Shift+L".action.move-column-right = [ ];
          "Mod+Shift+J".action.move-window-down = [ ];
          "Mod+Shift+K".action.move-window-up = [ ];
          "Mod+O".action.toggle-overview = [ ];

          # Workspaces
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;

          # Sizing
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+F".action.maximize-column = [ ];
          "Mod+Shift+F".action.fullscreen-window = [ ];

          # Launcher
          "Mod+Space".action.spawn = [ "anyrun" ];

          # Screenshot
          "Print".action.spawn = [ "grimblast" "copy" "area" ];
          "Shift+Print".action.spawn = [ "grimblast" "save" "area" ];

          "Mod+A".action.spawn = [ "pavucontrol" ];

          # System
          "Mod+Shift+E".action.quit = [ ];
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
  };

  # Additional Wayland utilities
  home.packages = with pkgs; [
    swaybg

    wl-clipboard
    wl-mirror
    wayland-utils
    grimblast # Screenshot utility

    pavucontrol
  ];
}
