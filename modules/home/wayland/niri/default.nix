{ config, pkgs, theme, ... }:

{
  imports = [
    ./binds.nix
    ./settings.nix
    ./startups.nix
    ./window-rules.nix
  ];

  # Additional Wayland utilities
  home.packages = with pkgs; [
    swaybg

    wl-clipboard
    wl-mirror
    wayland-utils
    grimblast # Screenshot utility

    pavucontrol
    playerctl # Media controls
    brightnessctl # Brightness controls
    swaylock # Screen locking
  ];
}
