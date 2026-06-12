{ pkgs, ... }:

{
  imports = [
    (import ../../features/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/wwn-0x5001b448b61d211b";
    })
    ./hardware-configuration.nix

    ../../features/hardware/gpu/amd.nix
    ../../features/gaming
  ];

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
}
