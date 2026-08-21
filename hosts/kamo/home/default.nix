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
  ];

  home.packages = with pkgs; [
    pixelorama
  ];

  programs.noctalia.settings.storage = {
    key_source = "file";
    key_file = "/run/agenix/noctalia-storage-key";
  };

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
