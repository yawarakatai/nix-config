{
  self,
  ...
}:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
    ../../../modules/desktop/niri/home/blur.nix
    ../../../modules/home/services/ura.nix
    ../../../modules/home/dev/herdr.nix
    ../../../modules/home/communication
    ../../../modules/home/creative
  ];

  # The Ally touchscreen is physically attached to the internal panel. Without
  # an explicit mapping, niri maps absolute touch input across all outputs.
  programs.niri.settings.input.touch.map-to-output = "eDP-1";

  # services.swayidle = {
  #   enable = true;
  #   timeouts = [
  #     {
  #       timeout = 300;
  #       command = "${osConfig.programs.niri.package}/bin/niri msg action power-off-monitors";
  #       resumeCommand = "${osConfig.programs.niri.package}/bin/niri msg action power-on-monitors";
  #     }
  #   ];
  # };
}
