{
  config,
  osConfig,
  pkgs,
  ...
}:

{
  programs.niri.settings.spawn-at-startup = [
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
