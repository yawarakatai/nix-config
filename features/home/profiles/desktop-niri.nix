{ self, ... }:

{
  imports = [
    ./desktop.nix
    ../compositor/common.nix
    ../../niri/home
    self.modules.homeManager.desktopNoctalia
  ];
}
