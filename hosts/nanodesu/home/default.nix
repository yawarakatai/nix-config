{ pkgs, ... }:

{
  imports = [
    ../../../features/home/profiles/desktop-niri.nix
    ../../../features/home/cli/juice.nix
  ];

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
