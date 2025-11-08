{ theme, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "waybar" ]; }
    { command = [ "mako" ]; }
    { command = [ "swaybg" "-i" theme.wallpaper "-m" "fit" ]; }
  ];
}
