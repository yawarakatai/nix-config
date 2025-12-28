{ config, pkgs, uiSettings, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # Font - will be configured by stylix

      # Colors - will be configured by stylix

      # Layout
      width = 400;
      height = 150;
      margin = "16";
      padding = "16";
      border-size = uiSettings.border.width;
      border-radius = uiSettings.rounding;

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
  };
}
