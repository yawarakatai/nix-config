{ pkgs, ... }:

{
  imports = [
    ../../../features/home/profiles/desktop-niri.nix
  ];

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
