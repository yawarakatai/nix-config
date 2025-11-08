{ config, pkgs, ... }:

{
  # Collection module for general Wayland utilities
  # These packages are compositor-agnostic and useful for any Wayland setup
  #
  # Note: This is a collection module (like cli-tools.nix)
  # Compositor-specific configs get their own modules (e.g., niri/, waybar.nix)
  # System-level Wayland configuration is in modules/system/wayland.nix
  home.packages = with pkgs; [
    # Wallpaper
    swaybg

    # Clipboard and screen utilities
    wl-clipboard # Wayland clipboard utilities
    wl-mirror # Screen mirroring
    wayland-utils # Wayland debugging tools
    grim # Screenshot tool (required by grimblast)
    slurp # Area selector (required by grimblast)
    grimblast # Screenshot utility wrapper

    # Screen locking
    swaylock # Screen locker

    # Media and system controls
    pavucontrol # PulseAudio volume control GUI
    playerctl # Media player controls
    brightnessctl # Brightness controls
  ];
}
