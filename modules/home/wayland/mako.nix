{ config, pkgs, theme, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # Font
      font = "${theme.font.family} ${toString theme.font.size}";

      # Colors
      background-color = theme.colorScheme.base00;
      text-color = theme.colorScheme.base05;
      border-color = theme.border.activeColor;
      progress-color = "over ${theme.semantic.variable}";

      # Layout
      width = 400;
      height = 150;
      margin = "16";
      padding = "16";
      border-size = theme.border.width;
      border-radius = theme.rounding;

      # Behavior
      default-timeout = 10000;
      ignore-timeout = false;

      # Grouping
      group-by = "app-name";
      max-visible = 5;
      sort = "-time";

      # Icons
      icons = true;
      max-icon-size = 48;
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

      # Actions
      actions = true;
    };

    # Extra configuration for urgency levels
    extraConfig = ''
      [urgency=low]
      border-color=${theme.semantic.info}
      default-timeout=3000

      [urgency=normal]
      border-color=${theme.semantic.warning}
      default-timeout=5000

      [urgency=critical]
      border-color=${theme.semantic.error}
      default-timeout=0
      ignore-timeout=1
    '';
  };
}
