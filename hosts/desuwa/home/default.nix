{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.gaming
    ../../../modules/home/dev/pi.nix
  ];
}
