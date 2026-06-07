{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ../compositor/common.nix
    ../../niri/home
    ../compositor/launcher/vicinae.nix
    ../compositor/notification/mako.nix
    ../../desktop/waybar.nix
  ];

  home.packages = with pkgs; [
    blueman
    wlogout
  ];
}
