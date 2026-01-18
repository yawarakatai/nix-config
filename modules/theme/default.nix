{ lib, ... }:
with lib;
{
  imports = [
    ./stylix.nix
  ];

  options.my.theme = {
    rounding = mkOption {
      type = types.int;
      default = 20;
    };
    gaps = {
      inner = mkOption {
        type = types.int;
        default = 0;
      };
      outer = mkOption {
        type = types.int;
        default = 0;
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
