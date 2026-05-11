{ osConfig, pkgs, ... }:

{
  imports = [
    ../../../modules/home/profiles/desktop.nix

    ../../../modules/home/browser/zen-browser.nix
    ../../../modules/home/creative
  ];

  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  home.packages = with pkgs; [ opencode ];

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
