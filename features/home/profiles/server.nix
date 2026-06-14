{ config, osConfig, ... }:

{
  imports = [
    ../dev/git.nix
    ../shell
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

  xdg.configFile."fastfetch/config.jsonc".source = ../fastfetch/config.jsonc;
}
