{
  inputs,
  lib,
  self,
  ...
}:

{
  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/services/hanas.nix
    ../../../modules/home/services/ura.nix
    ../../../modules/home/dev/herdr.nix
    ../../../modules/home/creative
    ../../../modules/home/creative/obs-studio.nix
  ];

  programs.niri = {
    config = lib.mkOptionDefault (
      lib.mkAfter [
        (inputs.niri.lib.kdl.leaf "include" [
          { optional = true; }
          "noctalia.kdl"
        ])
      ]
    );
    settings.debug.honor-xdg-activation-with-invalid-serial = [ ];
  };

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
