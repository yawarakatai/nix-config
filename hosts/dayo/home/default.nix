{ osConfig, ... }:

{
  imports = [
    ../../../modules/home/profiles
  ];

  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
