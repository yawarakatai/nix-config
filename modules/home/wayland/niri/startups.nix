{ vars, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "waybar" ]; }
    { command = [ "mako" ]; }
    { command = [ "swaybg" "-i" vars.wallpaperPath "-m" "fit" ]; }
  ];
}
