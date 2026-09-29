{ pkgs, self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/services/hanas.nix
  ];

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
