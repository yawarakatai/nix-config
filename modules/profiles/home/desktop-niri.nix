{ self, ... }:

{
  imports = [
    ./desktop.nix
    ../../home/compositor/common.nix
    self.modules.homeManager.homeNiri
    self.modules.homeManager.homeNoctalia
    self.modules.homeManager.homeGhostty
  ];
}
