{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlr-randr
    mpv
    playerctl
    brightnessctl
  ];
}
