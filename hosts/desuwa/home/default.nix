{ pkgs, ... }:

{
  imports = [
    ../../../features/home/profiles/desktop.nix
    ../../../features/home/creative
  ];

  home.packages = with pkgs; [
    opencode
    discord
    ungoogled-chromium
  ];
}
