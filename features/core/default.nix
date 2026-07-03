{ ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
  ];

  services.gvfs.enable = true;
  programs.dconf.enable = true;

}
