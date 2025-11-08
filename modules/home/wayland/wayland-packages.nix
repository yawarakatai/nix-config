{ config, pkgs, ... }:

{
  # General Wayland utilities and tools
  # These packages are compositor-agnostic and useful for any Wayland setup
  #
  # Note: System-level Wayland configuration (environment variables, XDG portal)
  # is in modules/system/wayland.nix
  home.packages = with pkgs; [
    # Wallpaper
    swaybg

    # Clipboard and screen utilities
    wl-clipboard      # Wayland clipboard utilities
    wl-mirror         # Screen mirroring
    wayland-utils     # Wayland debugging tools
    grimblast         # Screenshot utility

    # Screen locking
    swaylock          # Screen locker

    # Media and system controls
    pavucontrol       # PulseAudio volume control GUI
    playerctl         # Media player controls
    brightnessctl     # Brightness controls
  ];
}
