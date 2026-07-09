{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.my = {
    display.outputs = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Whether this display output is enabled.";
            };

            primary = mkOption {
              type = types.bool;
              default = false;
              description = "Whether this display is the preferred primary output.";
            };

            width = mkOption {
              type = types.int;
              default = 1920;
              description = "Display mode width in physical pixels.";
            };

            height = mkOption {
              type = types.int;
              default = 1080;
              description = "Display mode height in physical pixels.";
            };

            refresh = mkOption {
              type = types.float;
              default = 60.0;
              description = "Display refresh rate.";
            };

            scale = mkOption {
              type = types.float;
              default = 1.0;
              description = "Wayland output scale.";
            };

            vrr = mkOption {
              type = types.bool;
              default = false;
              description = "Whether VRR is enabled for this display.";
            };

            transform = mkOption {
              type = types.int;
              default = 0;
              description = "Display transform rotation.";
            };

            position = {
              x = mkOption {
                type = types.int;
                default = 0;
              };
              y = mkOption {
                type = types.int;
                default = 0;
              };
            };
          };
        }
      );
      default = { };
      description = "Niri display outputs keyed by output name.";
    };

    wallpaper = {
      image = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Shared wallpaper image used by Noctalia on all displays.";
      };

      fallbackColor = mkOption {
        type = types.str;
        default = "#0b0f14";
        description = "Solid background color used when no wallpaper image is configured.";
      };
    };

    ui.scale = mkOption {
      type = types.float;
      default = 1.0;
      description = "Global shell/UI scale preference for this device.";
    };
  };
}
