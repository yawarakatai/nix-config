# Common Wayland packages and utilities
# Compositor-agnostic packages useful for any Wayland setup
{ pkgs, ... }:

{
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

    # XWayland support for niri (niri uses xwayland-satellite for X11 apps)
    xwayland-satellite
  ];
}
