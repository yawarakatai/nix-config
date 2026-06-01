{
  config,
  osConfig,
  pkgs,
  ...
}:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "${pkgs.mako}/bin/mako" ]; }
    { command = [ "${pkgs.waybar}/bin/waybar" ]; }
    {
      command = [
        "${pkgs.swaybg}/bin/swaybg"
        "-i"
        "${osConfig.stylix.image}"
        "-m"
        "fill"
      ];
    }
  ];
}
