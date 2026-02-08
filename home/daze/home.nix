{ osConfig, ... }:

{
  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  home.stateVersion = "25.05";
}
