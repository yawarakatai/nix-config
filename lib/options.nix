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

    ui.scale = mkOption {
      type = types.float;
      default = 1.0;
      description = "Global shell/UI scale preference for this device.";
    };
  };
}
