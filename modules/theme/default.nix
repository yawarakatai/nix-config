{ lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./stylix.nix
  ];

  options.my.theme = {
    fonts = {
      monospace = {
        package = mkOption {
          type = types.package;
          default = pkgs.nerd-fonts.blex-mono;
          description = "Package providing the monospace font.";
        };

        name = mkOption {
          type = types.str;
          default = "BlexMono Nerd Font Mono";
          description = "Font family used for monospace text.";
        };
      };

      sansSerif = {
        package = mkOption {
          type = types.package;
          default = pkgs.noto-fonts-cjk-sans;
          description = "Package providing the sans-serif font.";
        };

        name = mkOption {
          type = types.str;
          default = "Noto Sans CJK JP";
          description = "Font family used for sans-serif text.";
        };
      };
    };

    rounding = mkOption {
      type = types.int;
      default = 0;
    };

    gaps = mkOption {
      type = types.int;
      default = 0;
    };

    terminal = {
      padding = mkOption {
        type = types.int;
        default = 20;
      };
    };

    transparency.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether transparent backgrounds and related effects are enabled.";
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
        default = true;
      };

      width = mkOption {
        type = types.int;
        default = 2;
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
}
