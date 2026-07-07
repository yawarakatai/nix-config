{
  self,
  ...
}:

{
  imports = [
    ./default.nix
    ../../home/dev/git.nix
    self.modules.homeManager.shell
  ];
}
