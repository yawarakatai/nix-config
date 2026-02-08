{ lib, ... }:
with lib;
{
  options.my = {
    user.name = mkOption {
      type = types.str;
      default = "yawarakatai";
    };

    system = {
      monitors = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              name = mkOption { type = types.str; };
              width = mkOption { type = types.int; };
              height = mkOption { type = types.int; };
              refresh = mkOption { type = types.float; };
              scale = mkOption {
                type = types.float;
                default = 1.0;
              };
              vrr = mkOption {
                type = types.bool;
                default = false;
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
      };
    };
  };
}
