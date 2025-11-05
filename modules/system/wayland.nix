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
    
    # SDL (games, emulators)
    SDL_VIDEODRIVER = "wayland";
    
    # Java applications
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
  
  # XDG Desktop Portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}