{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.minimal
  ];
}
