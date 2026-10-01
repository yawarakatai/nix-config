{
  inputs,
  lib,
  self,
  ...
}:

{
  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/services/ura.nix
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
  };

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
