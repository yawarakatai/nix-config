{ self, pkgs, ... }:

{
  home.packages = with pkgs; [
    pixelorama
  ];

  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/services/ura.nix
  ];
}
