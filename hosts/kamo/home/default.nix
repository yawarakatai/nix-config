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
  ];

  # Gaming Mode also starts graphical-session.target; keep the desktop shell
  # and other Home Manager Wayland services attached only to Niri.
  wayland.systemd.target = "niri.service";

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
