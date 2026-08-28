{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlr-randr
    swayimg
    mpv
    playerctl
    brightnessctl
  ];
}
