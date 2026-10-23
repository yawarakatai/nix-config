{ self, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    parabolic
  ];

  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
  ];
}
