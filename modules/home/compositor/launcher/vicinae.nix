{ inputs, uiSettings, ... }:

{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;

    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {
      faviconService = "twenty";

      popToRootOnClose = false;
      rootSearch.searchFiles = true;

      window = {
        csd = true;
        opacity = uiSettings.opacity.launcher;
        rounding = uiSettings.rounding;
      };
    };
  };
}
