# Module description
{ config, lib, pkgs, theme, vars, ... }:

let
  # termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  # Module options (uncomment if configurable)
  # options.myModule = {
  #   enable = lib.mkEnableOption "myModule";
  # };

  # config = lib.mkIf config.myModule.enable {

  programs.myprogram = {
    enable = true;

    settings = {
      # Use theme values, never hard-code
      background = theme.colorScheme.base00;
      foreground = theme.colorScheme.base05;
      accent = theme.semantic.info;

      font = {
        family = theme.font.name;
        size = theme.font.size;
      };

      opacity = theme.opacity.terminal;
    };
  };

  # };
}
