_:

{
  imports = [
    ./storage/disko.nix
    ./generated/hardware-configuration.nix
    ./hardware.nix
    ./system.nix
    ../../modules/storage/ephemeral-root.nix
    ../../modules/services/router.nix
    ../../modules/services/backup-server.nix
  ];
}
