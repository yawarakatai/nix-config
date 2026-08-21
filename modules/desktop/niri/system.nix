{
  inputs,
  lib,
  pkgs,
  ...
}:

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
              description = "Whether this is the preferred primary output.";
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

    niri = {
      rounding = mkOption {
        type = types.int;
        default = 0;
      };

      gaps = mkOption {
        type = types.int;
        default = 0;
      };

      border = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        width = mkOption {
          type = types.int;
          default = 1;
        };

        color = mkOption {
          type = types.str;
          default = "#DCC78E";
          description = "Color used for active compositor borders.";
        };

        inactiveColor = mkOption {
          type = types.str;
          default = "#1A1812";
          description = "Color used for inactive compositor borders.";
        };

        urgentColor = mkOption {
          type = types.str;
          default = "#D04428";
          description = "Color used for urgent compositor borders.";
        };
      };
    };
  };

  config = {
    programs.niri = {
      enable = true;
      package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };

    programs.xwayland.enable = true;
  };
}
