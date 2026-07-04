{ self, ... }:

{
  imports = [
    self.modules.homeManager.profiles.server
  ];
}
