{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./stylix.nix
    ./wallpaper.nix
  ];

  options.my.theme = {
    rounding = mkOption {
      type = types.int;
      default = 10;
    };

    gaps = mkOption {
      type = types.int;
      default = 14;
    };

    terminal = {
      padding = mkOption {
        type = types.int;
        default = 20;
      };
    };

    opacity = {
      terminal = mkOption {
        type = types.float;
        default = 0.85;
      };

      applications = mkOption {
        type = types.float;
        default = 1.0;
      };

      desktop = mkOption {
        type = types.float;
        default = 1.0;
      };

      popups = mkOption {
        type = types.float;
        default = 0.90;
      };

      shell = mkOption {
        type = types.float;
        default = 0.65;
      };

      shellPopups = mkOption {
        type = types.float;
        default = 0.78;
      };
    };

    border = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      width = mkOption {
        type = types.int;
        default = 0;
      };
    };
  };
}
