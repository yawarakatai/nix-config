{
  imports = [
    ./storage/disko.nix
    ./generated/hardware-configuration.nix
    ./hardware.nix
    ./system.nix
    ../../modules/gaming
    ../../modules/gaming/headless-host.nix
    ../../modules/services/udev.nix
    ../../modules/syncthing/identity.nix
  ];
}
