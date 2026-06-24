{
  osConfig,
  inputs,
  ...
}:

{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  programs.vicinae = {
    enable = true;

    systemd = {
      enable = true;
      autoStart = true;
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
