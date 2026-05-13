{ pkgs, ... }:

{
  imports = [
    ../../../features/home/profiles/desktop.nix

    ../../../features/home/browser/zen-browser.nix
    ../../../features/home/creative
  ];

  home.packages = with pkgs; [ opencode ];
}
