{ self, ... }:

{
  imports = [
    ./desktop.nix
    ../../home/compositor/common.nix
    self.modules.homeManager.desktopNiri
    self.modules.homeManager.desktopNoctalia
    self.modules.homeManager.desktopGhostty
  ];
}
