{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.default
  ];
}
