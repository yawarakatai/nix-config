{ pkgs, ... }:

{
  imports = [
    ../../../features/home/profiles/desktop-niri.nix
    ../../../features/home/creative
  ];

  home.packages = with pkgs; [
    discord
    ungoogled-chromium
  ];
}
