{ config, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "waybar" ]; }
    { command = [ "mako" ]; }
    {
      command = [
        "swaybg"
        "-i"
        "${config.stylix.image}"
        "-m"
        "fill"
      ];
    }
  ];
}
