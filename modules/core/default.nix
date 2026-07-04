{ ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./users.nix
  ];

  services.gvfs.enable = true;
  programs.dconf.enable = true;

}
