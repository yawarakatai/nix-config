{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.desktop
  ];
}
