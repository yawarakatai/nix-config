{ config, pkgs, theme, inputs, ... }:

{
  services.vicinae = {
    enable = true;
    autoStart = true;

    settings = {
      # Favicon service
      faviconService = "twenty"; # twenty | google | none

      # Font
      font.size = theme.font.size;

      # Behavior
      popToRootOnClose = false;
      rootSearch.searchFiles = true;

      # Theme
      theme.name = "vicinae-dark"; # or "vicinae-light"

      # Window settings
      window = {
        csd = true;
        opacity = theme.opacity.launcher;
        rounding = theme.rounding;
      };
    };

    # Extensions (optional)
    # extensions = [];
  };
}
