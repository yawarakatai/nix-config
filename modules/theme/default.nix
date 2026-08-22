{ lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./system.nix
  ];

  options.my.theme = {
    fonts = {
      monospace = {
        package = mkOption {
          type = types.package;
          default = pkgs.nerd-fonts.commit-mono;
          description = "Package providing the monospace font.";
        };

        name = mkOption {
          type = types.str;
          default = "CommitMono Nerd Font Mono";
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
    };
  };
}
