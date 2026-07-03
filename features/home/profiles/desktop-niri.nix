{ self, ... }:

{
  imports = [
    ./desktop.nix
    ../compositor/common.nix
    self.modules.homeManager.desktopNiri
    self.modules.homeManager.desktopNoctalia
    self.modules.homeManager.desktopGhostty
  ];
}
