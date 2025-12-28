{ uiSettings, inputs, ... }:

{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  # Theme file - will be configured by stylix

  services.vicinae = {
    enable = true;

    systemd = {
      enable = true; # default: false
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {
      # Favicon service
      faviconService = "twenty"; # twenty | google | none

      # Font - will be configured by stylix

      # Behavior
      popToRootOnClose = false;
      rootSearch.searchFiles = true;

      # Theme - will be configured by stylix

      # Window settings
      window = {
        csd = true;
        opacity = uiSettings.opacity.launcher;
        rounding = uiSettings.rounding;
      };
    };
  };
}
