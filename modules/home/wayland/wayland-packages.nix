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
    grim # Screenshot tool
    slurp # Area selector for screenshots
    libnotify # Notification utilities (notify-send)

    # Screen locking
    swaylock # Screen locker
  ];
}
