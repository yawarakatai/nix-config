{
  osConfig,
  self,
  ...
}:

{
  imports = [
    ../../home/dev/git.nix
    self.modules.homeManager.shell
  ];

  home = {
    username = osConfig.my.user.name;
    homeDirectory = "/home/${osConfig.my.user.name}";
    stateVersion = "25.05";
    enableNixpkgsReleaseCheck = false;
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  xdg.configFile."fastfetch/config.jsonc".source = ../../home/fastfetch/config.jsonc;
}
