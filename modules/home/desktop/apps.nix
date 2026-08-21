{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlr-randr
    nautilus
    loupe
    mpv
    pavucontrol
    playerctl
    brightnessctl
  ];
}
