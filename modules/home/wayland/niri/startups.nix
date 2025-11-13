{ vars, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; } # XWayland support for X11 apps like Steam
    { command = [ "waybar" ]; }
    { command = [ "mako" ]; }
    { command = [ "swaybg" "-i" vars.wallpaperPath "-m" "center" ]; }
  ];
}
