{ self, pkgs, ... }:

{
  home.packages = with pkgs; [
    bottles
    orca-slicer
  ];

  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
    ../../../modules/home/services/steam.nix
  ];
}
