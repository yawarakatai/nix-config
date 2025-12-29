{ config, pkgs, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "${pkgs.mako}/bin/mako" ]; }
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
