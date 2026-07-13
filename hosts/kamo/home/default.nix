{ osConfig, self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
    ../../../modules/home/services/ura.nix
    ../../../modules/home/dev/herdr.nix
  ];

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${osConfig.programs.niri.package}/bin/niri msg action power-off-monitors";
        resumeCommand = "${osConfig.programs.niri.package}/bin/niri msg action power-on-monitors";
      }
    ];
  };
}
