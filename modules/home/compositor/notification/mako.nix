{ osConfig, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # Layout
      width = 400;
      height = 150;
      margin = "16";
      padding = "16";
      border-size = osConfig.my.theme.border.width;
      border-radius = osConfig.my.theme.rounding;

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

      # Actions
      actions = true;
    };
  };
}
