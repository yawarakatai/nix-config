{ pkgs, ... }:

{
  imports = [
    (import ../../features/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/ata-SAMSUNG_MZNLN256HAJQ-00007_S3UBNX0M300285";
    })
    ./hardware-configuration.nix
    ../../features/laptop/power.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- Application and Service Settings ---;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  # --- My Options ---
  my = {
    system.monitors.primary = (import ../../displays).nanoda-builtin;
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
