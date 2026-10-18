{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
  ];
}
