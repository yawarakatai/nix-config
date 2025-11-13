{ config, pkgs, ... }:

{
  # Common packages used across all home configurations
  # These are everyday utilities that every user profile should have

  home.packages = with pkgs; [
    # System info
    neofetch
    htop
    tree

    # File manager
    nautilus

    # Image viewer
    imv

    # Markdown reader
    glow

    # Media and system controls
    pavucontrol # PulseAudio volume control GUI
    playerctl # Media player controls
    brightnessctl # Brightness controls
  ];
}
