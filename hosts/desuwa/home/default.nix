{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
    ../../../modules/home/creative
  ];
}
