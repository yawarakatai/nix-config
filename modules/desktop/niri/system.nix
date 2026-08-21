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
  options.my.niri = {
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

  config = {
    programs.niri = {
      enable = true;
      package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };

    programs.xwayland.enable = true;
  };
}
