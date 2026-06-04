{ lib, ... }:
with lib;
{
  imports = [
    ./stylix.nix
  ];

  options.my.theme = {
    rounding = mkOption {
      type = types.int;
      default = 0;
    };
    gaps = mkOption {
      type = types.int;
      default = 20;
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
