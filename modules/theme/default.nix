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
          default = pkgs.nerd-fonts.jetbrains-mono;
          description = "Package providing the monospace font.";
        };

        name = mkOption {
          type = types.str;
          default = "JetBrainsMono Nerd Font";
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
  };
}
