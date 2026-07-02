{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ../compositor/common.nix
    ../../niri/home
    ../../desktop/noctalia.nix
  ];

  home.packages = with pkgs; [
    blueman
    wlogout
  ];
}
