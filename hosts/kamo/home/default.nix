{
  osConfig,
  pkgs,
  self,
  ...
}:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
    ../../../modules/home/services/ura.nix
    ../../../modules/home/dev/herdr.nix
    ../../../modules/home/communication
  ];

  home.packages = with pkgs; [
    prismlauncher
    pixelorama
    kicad
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
