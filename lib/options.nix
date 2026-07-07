{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.my = {
    system.monitors.primary = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "Primary monitor output name.";
      };

      width = mkOption {
        type = types.int;
        default = 1920;
        description = "Primary monitor physical pixel width.";
      };

      height = mkOption {
        type = types.int;
        default = 1080;
        description = "Primary monitor physical pixel height.";
      };

      refresh = mkOption {
        type = types.float;
        default = 60.0;
        description = "Primary monitor refresh rate.";
      };

      scale = mkOption {
        type = types.float;
        default = 1.0;
        description = "Wayland output scale.";
      };

      vrr = mkOption {
        type = types.bool;
        default = false;
        description = "Whether VRR is enabled for the primary monitor.";
      };

      transform = mkOption {
        type = types.int;
        default = 0;
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

    ui = {
      scale = mkOption {
        type = types.float;
        default = 1.0;
        description = "Global shell/UI scale preference for this device.";
      };

      density = mkOption {
        type = types.enum [
          "compact"
          "normal"
          "comfortable"
        ];
        default = "compact";
        description = "General UI density preference.";
      };

      bar = {
        position = mkOption {
          type = types.enum [
            "top"
            "bottom"
            "left"
            "right"
          ];
          default = "bottom";
          description = "Main shell bar position.";
        };

        thicknessRatio = mkOption {
          type = types.float;
          default = 0.012;
          description = "Bar thickness as a ratio of the relevant monitor dimension.";
        };

        minThickness = mkOption {
          type = types.int;
          default = 32;
          description = "Minimum bar thickness in pixels.";
        };

        maxThickness = mkOption {
          type = types.int;
          default = 48;
          description = "Maximum bar thickness in pixels.";
        };

        padding = mkOption {
          type = types.int;
          default = 10;
          description = "Bar internal padding.";
        };

        marginEndsRatio = mkOption {
          type = types.float;
          default = 0.333;
          description = "Bar end margin as a ratio of monitor width.";
        };

        maxMarginEnds = mkOption {
          type = types.int;
          default = 1280;
          description = "Maximum bar end margin.";
        };
      };
    };
  };
}
