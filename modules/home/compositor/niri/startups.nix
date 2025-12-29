{ config, ... }:

{
  programs.niri.settings.spawn-at-startup = [
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
