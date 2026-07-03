{ pkgs, self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
  ];

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
