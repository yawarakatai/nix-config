{ config, pkgs, ... }:

{
  # Wayland environment variables
  environment.sessionVariables = {
    # Electron apps (VSCode, etc.)
    NIXOS_OZONE_WL = "1";

    # Firefox
    MOZ_ENABLE_WAYLAND = "1";

    # Qt applications
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # SDL (games, emulators) - allow X11 fallback for compatibility (e.g., Steam)
    SDL_VIDEODRIVER = "wayland,x11";

    # Java applications
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # XDG Desktop Portal for Wayland
  # Note: niri uses xdg-desktop-portal-gnome for screen capture (not wlr)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    # Explicitly route screencast and screenshot to gnome backend for niri
    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      "org.freedesktop.impl.portal.Screenshot" = "gnome";
    };
  };
}
