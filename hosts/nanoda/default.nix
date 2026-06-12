{ pkgs, ... }:

{
  imports = [
    (import ../../features/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/ata-SAMSUNG_MZNLN256HAJQ-00007_S3UBNX0M300285";
    })
    ./hardware-configuration.nix
    ../../features/laptop/power.nix
  ];

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
}
