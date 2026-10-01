{ pkgs, self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktop
  ];

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
