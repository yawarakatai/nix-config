{ self, ... }:

{
  imports = [
    ./desktop.nix
    self.modules.homeManager.homeNiri
    self.modules.homeManager.homeNoctalia
    self.modules.homeManager.homeGhostty
    ../../home/communication
  ];
}
