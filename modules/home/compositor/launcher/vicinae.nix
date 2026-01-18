{
  osConfig,
  inputs,
  ...
}:

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
      theme.light.name = "stylix";
      theme.dark.name = "stylix";

      faviconService = "twenty";

      popToRootOnClose = false;
      rootSearch.searchFiles = true;

      window = {
        csd = true;
        rounding = osConfig.my.theme.rounding;
      };
    };
  };
}
