{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
  ];
}
