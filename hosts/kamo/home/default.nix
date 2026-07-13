{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
    ../../../modules/home/services/ura.nix
    ../../../modules/home/dev/herdr.nix
  ];
}
