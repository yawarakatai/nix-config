{ lib, ... }:

{
  imports = [
    ./disko.nix
  ];

  fileSystems = lib.mkForce {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_NVME";
      fsType = "ext4";
    };
  };
}
